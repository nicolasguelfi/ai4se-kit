#!/usr/bin/env bash
# AI4SE — a local Ubuntu 24.04 desktop VM on a Mac (Apple Silicon, VirtualBox 7.1+),
# reachable by RDP, to rehearse the course VM template (trainer/vm-template/README.md).
# On a new Mac (Homebrew, VirtualBox, optional Tailscale, VM folder outside Dropbox): run
# setup-mac-vm.sh next to this file instead — it installs what is missing, then calls this script.
#
#   bash create-local-vm.sh                 create and boot the VM (≈ 25 min the first time)
#   bash create-local-vm.sh --status        is the first-boot setup finished?
#   bash create-local-vm.sh --delete        power off and delete the VM and its folder
#
# Result: GNOME desktop, user "student" (password "student" unless VM_PASSWORD is set),
# xrdp, VS Code, docker.io, keyboard Mac AZERTY first (then ch, fr, us like the lab VM),
# time zone Europe/Luxembourg. RDP on 127.0.0.1:3390, SSH on 127.0.0.1:2222 (bound to the Mac
# itself), plus RDP on <mac-tailscale-ip>:3390 when Tailscale is up on the Mac (TAILSCALE_RDP=0 to skip).
# Then connect with Windows App: add PC "localhost:3390", user student, session Xorg.
# The Mac AZERTY layout is forced by a GNOME autostart once the desktop is up: xrdp starts its
# Xorg session in US layout, and setxkbmap in ~/.xsessionrc gave a black RDP screen (2026-11-23).
#
# Remote access while travelling (two ways, both keep the VM off the public internet):
#   - Chrome Remote Desktop to the Mac, then Windows App on the Mac → localhost:3390;
#   - Tailscale: RDP to <mac-tailscale-name>:3390 (forward added at creation, see above).
#     The password stays "student" on purpose (rehearsal VM, no secrets inside): every device of
#     your tailnet can reach the port, so keep the tailnet to your own devices, or set VM_PASSWORD.
#     Some company networks block Tailscale; Chrome Remote Desktop (HTTPS) usually still works there.
# Snapshots: take them with the VM running but WITHOUT --live (--live crashed the VM, 2026-11-23).
#
# Needs: VirtualBox 7.1+ (Apple Silicon build), Homebrew (qemu-img is installed if missing).
# Settings (environment): VM_NAME=ai4se-ubuntu VM_BASE=/Volumes/Mac_Data/VMs VM_PASSWORD=student
#   VM_RAM_MB=8192 VM_CPUS=4 VM_DISK_GB=60 RDP_PORT=3390 SSH_PORT=2222
# Keep VM_BASE outside Dropbox/iCloud (a 10-20 GB disk image must not be synchronised).

set -euo pipefail

VM_NAME="${VM_NAME:-ai4se-ubuntu}"
VM_BASE="${VM_BASE:-/Volumes/Mac_Data/VMs}"
VM_PASSWORD="${VM_PASSWORD:-student}"
VM_RAM_MB="${VM_RAM_MB:-8192}"
VM_CPUS="${VM_CPUS:-4}"
VM_DISK_GB="${VM_DISK_GB:-60}"
RDP_PORT="${RDP_PORT:-3390}"
SSH_PORT="${SSH_PORT:-2222}"
IMG_URL="https://cloud-images.ubuntu.com/noble/current"
IMG_NAME="noble-server-cloudimg-arm64.img"
HERE=$(cd "$(dirname "$0")" && pwd)
D="$VM_BASE/$VM_NAME"

say()  { printf '\n== %s\n' "$*"; }
step() { printf '  - %s\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
vmssh() { ssh -q -i "$D/vmkey" -p "$SSH_PORT" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
            -o ConnectTimeout=5 student@127.0.0.1 "$@"; }

case "${1:-}" in
  --status)
    s=$(vmssh 'cloud-init status' 2>/dev/null || true)
    printf '%s\n' "${s:-not reachable yet (still booting or installing)}"; exit 0 ;;
  --delete)
    VBoxManage controlvm "$VM_NAME" poweroff >/dev/null 2>&1 || true
    VBoxManage unregistervm "$VM_NAME" --delete >/dev/null 2>&1 || true
    rm -rf -- "$D"; say "VM $VM_NAME deleted ($D)"; exit 0 ;;
  "") ;;
  *) die "unknown option $1 (--status, --delete)" ;;
esac

[ "$(uname -s)/$(uname -m)" = "Darwin/arm64" ] || die "this script targets a Mac with Apple Silicon"
command -v VBoxManage >/dev/null || die "VirtualBox is not installed (virtualbox.org, Apple Silicon build)"
VBoxManage list vms | grep -q "\"$VM_NAME\"" && die "a VM named $VM_NAME already exists (use --delete first)"
command -v qemu-img >/dev/null || { say "Installing qemu-img (Homebrew qemu)"; brew install qemu; }

say "1. Ubuntu 24.04 ARM cloud image (checked against Ubuntu's SHA256SUMS)"
mkdir -p "$D"; cd "$D"
curl -fsSL -o SHA256SUMS "$IMG_URL/SHA256SUMS"
want=$(grep " \*$IMG_NAME\$" SHA256SUMS | cut -d' ' -f1)
if [ ! -f base.img ] || [ "$(shasum -a 256 base.img | cut -d' ' -f1)" != "$want" ]; then
  curl -fL --progress-bar -o base.img "$IMG_URL/$IMG_NAME"
fi
[ "$(shasum -a 256 base.img | cut -d' ' -f1)" = "$want" ] || die "checksum mismatch for $IMG_NAME"
step "image OK"

say "2. First-boot configuration (cloud-init)"
[ -f vmkey ] || ssh-keygen -q -t ed25519 -N '' -C "$VM_NAME-local" -f vmkey
mkdir -p seed
printf 'instance-id: %s-1\nlocal-hostname: %s\n' "$VM_NAME" "$VM_NAME" > seed/meta-data
HASH=$(openssl passwd -6 "$VM_PASSWORD")
sed -e "s|@PASSWORD_HASH@|$HASH|" -e "s|@SSH_KEY@|$(cat vmkey.pub)|" "$HERE/user-data.template" > seed/user-data
rm -f seed.iso
hdiutil makehybrid -quiet -iso -joliet -default-volume-name cidata -o seed.iso seed
step "seed.iso written"

say "3. Disk (${VM_DISK_GB} GB, grows on demand)"
rm -f disk.vdi
qemu-img convert -O vdi base.img disk.vdi
VBoxManage modifymedium disk "$D/disk.vdi" --resize $((VM_DISK_GB * 1024)) >/dev/null
step "disk.vdi ready"

say "4. VirtualBox VM"
# Apple Silicon notes (VirtualBox 7.1): platform "arm", EFI, graphics vmsvga, NIC virtio,
# storage VirtIO-SCSI; boot from disk first (the seed ISO is not bootable, it is only read
# by cloud-init).
VBoxManage createvm --name "$VM_NAME" --platform-architecture arm --ostype Ubuntu_arm64 \
  --basefolder "$VM_BASE" --register >/dev/null
VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM_MB" --cpus "$VM_CPUS" --firmware efi
VBoxManage modifyvm "$VM_NAME" --graphicscontroller vmsvga --vram 64
VBoxManage modifyvm "$VM_NAME" --nic1 nat --nictype1 virtio
VBoxManage modifyvm "$VM_NAME" --natpf1 "rdp,tcp,127.0.0.1,$RDP_PORT,,3389" --natpf1 "ssh,tcp,127.0.0.1,$SSH_PORT,,22"
TS_IP=""
if [ "${TAILSCALE_RDP:-1}" = 1 ] && command -v tailscale >/dev/null; then TS_IP=$(tailscale ip -4 2>/dev/null | head -n 1 || true); fi
if [ -n "$TS_IP" ]; then
  VBoxManage modifyvm "$VM_NAME" --natpf1 "rdp-tailscale,tcp,$TS_IP,$RDP_PORT,,3389"
  step "RDP also on Tailscale $TS_IP:$RDP_PORT"
else
  step "no Tailscale address: RDP on localhost only"
fi
VBoxManage modifyvm "$VM_NAME" --audio-enabled off --usb-xhci on --mouse usbtablet --keyboard usb
VBoxManage modifyvm "$VM_NAME" --boot1 disk --boot2 dvd --boot3 none --boot4 none
VBoxManage storagectl "$VM_NAME" --name VirtIO --add virtio --controller VirtIO-SCSI --portcount 4
VBoxManage storageattach "$VM_NAME" --storagectl VirtIO --port 0 --device 0 --type hdd --medium "$D/disk.vdi"
VBoxManage storageattach "$VM_NAME" --storagectl VirtIO --port 1 --device 0 --type dvddrive --medium "$D/seed.iso"
step "VM $VM_NAME created in $D"

say "5. First boot (installs the desktop, then reboots by itself)"
VBoxManage startvm "$VM_NAME" --type headless >/dev/null
for i in $(seq 1 240); do
  s=$(vmssh 'cloud-init status' 2>/dev/null || true)
  case "$s" in *done*|*error*) break ;; esac
  sleep 10
done
step "cloud-init: ${s:-no answer after 40 min — check with: bash $0 --status}"
case "$s" in *error*) vmssh 'sudo cloud-init status --long' || true ;; esac
# wait for the reboot that cloud-init asked for, then for xrdp
sleep 30
for i in $(seq 1 60); do vmssh 'systemctl is-active xrdp' 2>/dev/null | grep -q '^active' && break; sleep 5; done
vmssh 'systemctl is-active xrdp' 2>/dev/null | grep -q '^active' && step "xrdp running" || step "xrdp not confirmed yet"

say "Done"
cat <<EOF
  Connect: Windows App → + → Add PC → PC name: localhost:$RDP_PORT → user: student, password: $VM_PASSWORD, session Xorg
  ${TS_IP:+From another device on your tailnet: PC name $TS_IP:$RDP_PORT (same user and password).}
  Do not open a session on the VirtualBox window at the same time (one desktop session per user).
  Keyboard: Mac AZERTY is set a few seconds after login; picking a layout in the top-right menu replaces it.
  Snapshots with the VM running: no --live option (it crashed the VM on 2026-11-23).
  Keyboard: Mac AZERTY is the first layout; switch layouts with the indicator at the top right.
  Before your tests: VBoxManage snapshot $VM_NAME take clean   (back to it: snapshot $VM_NAME restore clean)
  Stop: VBoxManage controlvm $VM_NAME acpipowerbutton   Start: VBoxManage startvm $VM_NAME --type headless
  Delete everything: bash $0 --delete
EOF
