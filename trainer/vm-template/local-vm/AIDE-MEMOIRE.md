# Aide-mémoire — la VM de répétition sur plusieurs Mac

Chaque commande est seule dans son bloc : copier, coller dans le Terminal du **Mac** (jamais dans la VM), Entrée.
Les noms entre `<…>` sont à remplacer. Aide complète : `vm --help`.

Pour chaque commande, deux lignes disent **dans quel état doit être la VM** et **ce qu'il faut faire de la fenêtre
Windows App**. Règle générale : **aucune commande n'exige de se déconnecter (logoff) dans Ubuntu**, ni de quitter
l'application Windows App. Quand la VM s'arrête ou redémarre, la fenêtre perd simplement la connexion :
**enregistre d'abord tes fichiers ouverts dans la VM**, puis reconnecte-toi au même PC quand la VM est revenue.

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

Créer une VM neuve (installe aussi Homebrew et VirtualBox, ≈ 25 min), depuis le dossier `local-vm` du kit :

```bash
bash setup-mac-vm.sh
```

## 1. Au quotidien

**Où en est la VM**

- VM : n'importe quel état
- Windows App : rien à faire, la fenêtre peut rester ouverte

```bash
vm status
```

**Démarrer**

- VM : arrêtée (si elle tourne déjà, la commande le dit et ne fait rien)
- Windows App : pas encore de fenêtre : te connecter une fois la commande finie

```bash
vm start
```

**Infos de connexion et ouverture de Windows App**

- VM : allumée
- Windows App : ouvre l'application ; PC `localhost:3390`, `student` / `student`, session Xorg

```bash
vm connect
```

**Arrêter proprement**

- VM : allumée
- Windows App : la connexion se coupe ; enregistre d'abord tes fichiers dans la VM

```bash
vm stop
```

**Terminal dans la VM (sans passer par Windows App)**

- VM : allumée
- Windows App : rien à faire
- `exit` ou `Ctrl + D` pour en sortir

```bash
vm ssh
```

## 2. Se protéger

**Instantané (nom de ton choix)**

- VM : allumée ou arrêtée
- Windows App : peut rester ouverte, **pas besoin de logoff** ; la VM se fige quelques secondes puis repart — ne tape rien pendant ce temps
- VM allumée : l'instantané garde aussi les fenêtres ouvertes et la mémoire ; pour un état « propre », enregistre tes fichiers avant

```bash
vm snap <nom>
```

**Liste des instantanés**

- VM : n'importe quel état
- Windows App : rien à faire

```bash
vm snaps
```

**Revenir à un instantané**

- VM : n'importe quel état (la commande l'éteint elle-même, demande confirmation, puis la redémarre)
- Windows App : la connexion se coupe ; tout ce qui a été fait depuis l'instantané est perdu ; reconnecte-toi ensuite

```bash
vm restore <nom>
```

**Supprimer un instantané**

- VM : n'importe quel état
- Windows App : rien à faire

```bash
vm snap-delete <nom>
```

**Sauvegarde complète (≈ 7 min) dans `~/VMs/backups/ai4se-ubuntu/`**

- VM : allumée ou arrêtée ; si elle est allumée, la commande l'arrête pendant la copie puis la redémarre
- Windows App : la connexion se coupe pendant ≈ 7 min ; enregistre d'abord tes fichiers ; reconnecte-toi à la fin

```bash
vm backup
```

## 3. Passer d'un Mac à un autre

**Règle d'or :** une seule copie active à la fois. Avant de quitter un Mac, toujours `vm backup`.

### Sur le Mac que tu quittes

**Sauvegarde complète**

- VM : allumée ou arrêtée (arrêtée pendant la copie)
- Windows App : la connexion se coupe ; enregistre d'abord tes fichiers

```bash
vm backup
```

Transfert de `~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz` par AirDrop ou disque externe (pas Dropbox).

### Sur l'autre Mac

**Ranger l'archive reçue**

- VM : —
- Windows App : —

```bash
mkdir -p ~/VMs/backups/ai4se-ubuntu && mv ~/Downloads/ai4se-ubuntu-*.tar.gz ~/VMs/backups/ai4se-ubuntu/
```

S'il a **déjà** une VM `ai4se-ubuntu` (`VBoxManage list vms` l'affiche) — sinon, passer à l'import :

**1) L'arrêter**

- VM : allumée
- Windows App : ferme la fenêtre de cette VM

```bash
vm stop
```

**2) La retirer de VirtualBox (ses fichiers restent)**

- VM : arrêtée
- Windows App : —

```bash
VBoxManage unregistervm ai4se-ubuntu
```

**3) Mettre ses fichiers de côté**

- VM : retirée de VirtualBox
- Windows App : —

```bash
mv ~/VMs/ai4se-ubuntu ~/VMs/ai4se-ubuntu-ancienne
```

**Importer (remplacer `<date>` par celle de l'archive)**

- VM : aucune VM `ai4se-ubuntu` enregistrée sur ce Mac ; VirtualBox installé
- Windows App : pas encore de fenêtre : te connecter une fois la commande finie (elle démarre la VM)

```bash
vm import ~/VMs/backups/ai4se-ubuntu/ai4se-ubuntu-<date>.tar.gz
```

**Vérifier l'état**

- VM : allumée
- Windows App : rien à faire

```bash
vm status
```

**Vérifier que les instantanés ont suivi**

- VM : n'importe quel état
- Windows App : rien à faire

```bash
vm snaps
```

## 4. Problèmes fréquents

**Écran gris ou noir dans Windows App**

- VM : allumée
- Windows App : **ferme d'abord la fenêtre** de cette VM, lance la commande, puis reconnecte-toi et attends une minute

```bash
vm fix-rdp
```

**La touche `m` donne `;`**

- VM : allumée
- Windows App : **garde la fenêtre ouverte** (la commande agit sur la session ouverte)

```bash
vm keyboard
```

**La VM ne répond plus**

- VM : allumée (figée ou non)
- Windows App : la connexion se coupe ; reconnecte-toi ensuite

```bash
vm restart
```

**Toujours rien (coupure brutale, dernier recours)**

- VM : allumée
- Windows App : la connexion se coupe ; ce qui n'était pas enregistré dans la VM est perdu

```bash
vm reset
```

**« already locked by a session »**

- VM : la VM tourne encore ou est en train de s'arrêter : regarde son état
- Windows App : rien à faire

```bash
vm status
```

**`ssh` bloqué sur « Setting up xterm-ghostty » : Ctrl+C, puis**

- VM : allumée
- Windows App : rien à faire

```bash
vm ssh
```

**Une étape a tout cassé dans la VM**

- VM : n'importe quel état
- Windows App : la connexion se coupe ; ce qui a été fait depuis l'instantané est perdu

```bash
vm restore <dernier-instantané-bon>
```

**VirtualBox dit la VM « inaccessible »** : importer la dernière sauvegarde (section 3), ou demander à Claude.

**Problème inconnu — diagnostic à coller à Claude**

- VM : n'importe quel état (si la VM ne répond pas, la commande prend une capture de son écran)
- Windows App : rien à faire

```bash
vm diag
```

Plusieurs VM : préfixer par le nom, par exemple :

```bash
VM_NAME=<autre-vm> vm status
```

## 5. Raccourcis clavier dans la VM (Ubuntu, via Windows App)

**À retenir d'abord.** Dans la VM, c'est **Ctrl** qui copie, colle, enregistre — comme sous Windows,
même sur un Mac. La touche **⌘ Cmd** du Mac y devient la touche **Super** (la touche Windows) : `Cmd + C`
ne copie donc pas dans la VM. Dans le **Terminal** d'Ubuntu, il faut en plus **Maj** : `Ctrl + Maj + C` /
`Ctrl + Maj + V` (car `Ctrl + C` y interrompt la commande en cours).

### Copier / coller

| Où | Copier | Coller |
|---|---|---|
| Dans une application de la VM (Firefox, éditeur, VS Code…) | `Ctrl + C` | `Ctrl + V` |
| Dans le Terminal de la VM | `Ctrl + Maj + C` | `Ctrl + Maj + V` |
| Du Mac vers la VM | `⌘ + C` sur le Mac | `Ctrl + V` dans la VM (`Ctrl + Maj + V` dans son Terminal) |
| De la VM vers le Mac | `Ctrl + C` dans la VM (`Ctrl + Maj + C` dans son Terminal) | `⌘ + V` sur le Mac |
| Du PC Windows vers la VM, et retour | `Ctrl + C` | `Ctrl + V` (`Ctrl + Maj + V` dans le Terminal de la VM) |
| Copie rapide, dans la VM seulement | sélectionner le texte à la souris | clic du milieu (molette) |

Le copier-coller entre l'ordinateur et la VM passe par Windows App : s'il ne marche pas, vérifier dans
Windows App → clic droit sur le PC → Modifier → **Presse-papiers** coché, puis se reconnecter.
Le texte passe bien ; pour des fichiers, passer plutôt par `git` ou un dossier partagé.

### Bureau Ubuntu (GNOME)

| Action | Mac | Windows |
|---|---|---|
| Vue d'ensemble, chercher une application | `⌘` | `Win` |
| Liste des applications | `⌘ + A` | `Win + A` |
| Ouvrir un Terminal | `Ctrl + Alt + T` | `Ctrl + Alt + T` |
| Passer d'une fenêtre à l'autre (dans la VM) | `Alt + Tab` (⌥ + Tab) | `Alt + Tab` |
| Agrandir / restaurer la fenêtre | `⌘ + ↑` / `⌘ + ↓` | `Win + ↑` / `Win + ↓` |
| Fenêtre sur la moitié gauche / droite | `⌘ + ←` / `⌘ + →` | `Win + ←` / `Win + →` |
| Fermer la fenêtre | `Alt + F4` (⌥ + fn + F4) | `Alt + F4` |
| Changer de disposition de clavier | `⌘ + Espace` | `Win + Espace` |
| Capture d'écran (dans la VM) | `Maj + Impr` si la touche existe ; sinon menu en haut à droite | `Maj + Impr` |

### Terminal (dans la VM)

| Action | Raccourci (Mac et Windows) |
|---|---|
| Interrompre la commande en cours | `Ctrl + C` |
| Nouvel onglet / nouvelle fenêtre | `Ctrl + Maj + T` / `Ctrl + Maj + N` |
| Compléter un nom de fichier ou de commande | `Tab` (deux fois : toutes les possibilités) |
| Rappeler les commandes précédentes | `↑` / `↓` |
| Chercher dans l'historique | `Ctrl + R` |
| Début / fin de ligne | `Ctrl + A` / `Ctrl + E` |
| Effacer l'écran | `Ctrl + L` |
| Quitter le terminal ou la session SSH | `Ctrl + D` |
| Agrandir / réduire le texte | `Ctrl + Maj + +` / `Ctrl + -` |

### Applications courantes (dans la VM)

| Action | Raccourci (Mac et Windows) |
|---|---|
| Enregistrer / annuler / rétablir | `Ctrl + S` / `Ctrl + Z` / `Ctrl + Maj + Z` |
| Chercher dans la page ou le fichier | `Ctrl + F` |
| Fichiers : taper un chemin / afficher les fichiers cachés | `Ctrl + L` / `Ctrl + H` |
| VS Code : palette de commandes / terminal intégré | `Ctrl + Maj + P` / ``Ctrl + ` `` |

### Fenêtre Windows App (côté Mac)

| Action | Raccourci |
|---|---|
| Plein écran / sortir du plein écran | `Ctrl + ⌘ + F` |
| Revenir à une application du Mac | `⌘ + Tab` (géré par macOS, pas par la VM) |

Caractères spéciaux avec le clavier Mac AZERTY (`| \ { } [ ] ~`) : en principe les **mêmes touches que
sur le Mac**, avec ⌥ Option (la VM utilise la disposition « French (Macintosh) »). Si un caractère ne sort
pas comme prévu : `vm keyboard` depuis le Mac, puis réessayer.
