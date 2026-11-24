# Aide-mémoire — la VM de répétition sur plusieurs Mac

Chaque commande est seule dans son bloc : copier, coller dans le Terminal du **Mac**, Entrée.
Les noms entre `<…>` sont à remplacer. Aide complète : `vm --help`.

## 0. Une fois par Mac

Raccourci `vm` (ensuite, `vm …` marche depuis n'importe quel dossier) :

```bash
echo "alias vm='bash \"/Volumes/Mac_Data/Win_data/data/backups/Dropbox-nicolas.guelfi@laposte.net/messir Dropbox/Nicolas Guelfi/users/NG/Projets/AISE/ROS/trainings/AI4SE/githubs/ai4se-kit/trainer/vm-template/local-vm/vm.sh\"'" >> ~/.zshrc && exec $SHELL
```

Windows App :

```bash
brew install --cask windows-app
```

VirtualBox seul (pour importer une VM existante) :

```bash
brew install --cask virtualbox
```

Créer une VM neuve (installe aussi Homebrew et VirtualBox, ≈ 25 min), depuis ce dossier :

```bash
bash setup-mac-vm.sh
```

## 1. Au quotidien

Où en est la VM :

```bash
vm status
```

Démarrer :

```bash
vm start
```

Infos de connexion et ouverture de Windows App (`localhost:3390`, `student` / `student`, session Xorg) :

```bash
vm connect
```

Arrêter proprement :

```bash
vm stop
```

Terminal dans la VM :

```bash
vm ssh
```

## 2. Se protéger

Instantané (nom de ton choix) :

```bash
vm snap <nom>
```

Liste des instantanés :

```bash
vm snaps
```

Revenir à un instantané (ce qui a été fait depuis est perdu) :

```bash
vm restore <nom>
```

Supprimer un instantané :

```bash
vm snap-delete <nom>
```

Sauvegarde complète dans `~/VMs/backups/ai4se-ubuntu/` (≈ 7 min, VM arrêtée pendant la copie) :

```bash
vm backup
```

## 3. Passer d'un Mac à un autre

**Règle d'or :** une seule copie active à la fois. Avant de quitter un Mac, toujours `vm backup`.

Sur le Mac que tu quittes :

```bash
vm backup
```

Transfert de `~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz` par AirDrop ou disque externe (pas Dropbox).
Sur l'autre Mac, ranger l'archive reçue :

```bash
mkdir -p ~/VMs/backups/ai4se-ubuntu && mv ~/Downloads/ai4se-ubuntu-*.tar.gz ~/VMs/backups/ai4se-ubuntu/
```

S'il a déjà une VM `ai4se-ubuntu` (sinon passer) — l'arrêter, la retirer de VirtualBox, garder ses fichiers de côté :

```bash
vm stop
```

```bash
VBoxManage unregistervm ai4se-ubuntu
```

```bash
mv ~/VMs/ai4se-ubuntu ~/VMs/ai4se-ubuntu-ancienne
```

Importer (remplacer `<date>` par celle de l'archive) :

```bash
vm import ~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz
```

Vérifier :

```bash
vm status
```

```bash
vm snaps
```

## 4. Problèmes fréquents

Écran gris ou noir dans Windows App (fermer la fenêtre, lancer, se reconnecter) :

```bash
vm fix-rdp
```

La touche `m` donne `;` (fenêtre ouverte, sans la fermer) :

```bash
vm keyboard
```

La VM ne répond plus :

```bash
vm restart
```

Toujours rien (coupure brutale, dernier recours) :

```bash
vm reset
```

« already locked by a session » : la VM tourne ou s'arrête encore — regarder :

```bash
vm status
```

`ssh` bloqué sur « Setting up xterm-ghostty » : Ctrl+C, puis :

```bash
vm ssh
```

Une étape a tout cassé dans la VM :

```bash
vm restore <dernier-instantané-bon>
```

VirtualBox dit la VM « inaccessible » : importer la dernière sauvegarde (section 3), ou demander à Claude.

Problème inconnu — diagnostic à coller à Claude :

```bash
vm diag
```

Plusieurs VM : préfixer par le nom, par exemple :

```bash
VM_NAME=<autre-vm> vm status
```
