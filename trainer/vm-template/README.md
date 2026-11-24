# Préparer le modèle de machine virtuelle Ubuntu du cours (formateur)

Ce guide sert à finaliser **une fois** la machine modèle (le « template ») avant d'en créer
une copie par participant. Quatre scripts, dans l'ordre :

| Script | Lancé par | Ce qu'il fait |
|---|---|---|
| `1-system.sh` | `sudo` | outils du système : git, gh, Node.js LTS, python3, fuseau horaire, réglages de VS Code (IA de l'éditeur coupée, pas de fenêtres de mise à jour ni de recommandations) |
| `2-student.sh` | le compte `student` | réglages du bureau (pas de verrouillage d'écran, dock) ; **option** `--preinstall` : opencode 2, le kit, GSE-One |
| `3-seal.sh` | `sudo` | efface tout ce qui est personnel avant clonage (clé, connexion GitHub, identité git, historiques…) ; **à blanc par défaut**, efface seulement avec `--apply` |
| `4-verify.sh` | le compte `student` | contrôle en lecture seule : outils, rien de personnel, accès réseau aux sites du cours |

Aucun script n'installe de clé, ne se connecte à un compte ni n'écrit d'identité : la clé de
modèle, la connexion GitHub et l'identité git restent faites par chaque participant
(étapes 3 et 6 de l'installation du jour 1 après-midi).

Testé dans Ubuntu 24.04 (conteneur) : installation, deuxième passage sans effet, mode
`--preinstall`, nettoyage à blanc puis réel, contrôle avant et après. Pas testé : la partie
bureau GNOME (pas d'écran dans le conteneur), à vérifier à l'étape 3 ci-dessous.

## Avant de commencer

1. **Prenez un instantané (snapshot) de la VM** telle qu'elle est. Si quelque chose tourne
   mal, vous revenez en arrière en une minute.
2. Mettez les scripts dans la VM, par exemple dans `~/vm-template/` :
   - si le kit est publié : `git clone https://github.com/nicolasguelfi/ai4se-kit /tmp/kit && cp -r /tmp/kit/trainer/vm-template ~/`
   - sinon : copiez le dossier `trainer/vm-template` par le presse-papiers partagé, une clé USB ou `scp`.

## Les étapes

### Étape 1 — Système (≈ 10 min)

Dans un terminal de la VM, connecté en `student` :

```bash
cd ~/vm-template
sudo bash 1-system.sh
```

*Fini quand* il affiche « System part finished » sans ligne `ERROR`. Vous pouvez le relancer :
il ne refait que ce qui manque.

### Étape 2 — Compte étudiant : une décision à prendre

```bash
bash 2-student.sh                 # A. réglages du bureau seulement
bash 2-student.sh --preinstall    # B. + opencode 2, kit, GSE-One déjà installés
```

Lancez-le **depuis un terminal du bureau** (pas en SSH), sinon les réglages du bureau sont sautés.

| | A. Sans pré-installation (recommandé) | B. Avec `--preinstall` |
|---|---|---|
| Jour 1 après-midi | Les participants font les étapes 1 à 8 comme sur les diapositives ; les étapes 2 (Node) et l'installation de gh (étape 6) sont déjà faites : « déjà ≥ 20 ? sautez » | Les étapes 1, 2, 4 et 5 deviennent « vérifiez » ; il reste la clé (3), GitHub et l'identité (6), le contrôle (7), le tuteur (8) |
| Avantages | Ce qu'ils voient correspond aux diapositives ; ils apprennent où vivent les outils et sauront refaire l'installation sur leur machine ; le kit est cloné à jour le jour même | ≈ 20 min gagnées ; pas de risque si le réseau de la salle est lent quand 20 personnes téléchargent en même temps |
| Inconvénients | Dépend du réseau de la salle pendant 15-20 min | Le kit et opencode ont la version du jour où vous avez préparé le modèle : les participants doivent faire `~/ai4se/ai4se-kit/tutor update` au début (déjà dans la routine de chaque demi-journée) ; les diapositives d'installation décrivent des gestes déjà faits |
| Risque | Proxy ou réseau bloqué : le contrôle de l'étape 4 ci-dessous le détecte avant le cours | Préparer le modèle avant d'avoir publié le kit : les participants partent d'un kit ancien |

### Étape 3 — Tester comme un participant (≈ 15 min)

Le plus sûr : **testez sur une copie du modèle**, pas sur le modèle lui-même. Sinon, testez
dans le modèle puis nettoyez à l'étape 4.

1. Ouvrez VS Code : pas de fenêtre « Release Notes », pas de proposition d'extensions Docker,
   pas d'icône de chat ; ouvrir un fichier `.md` montre l'aperçu.
2. Vérifiez le clavier (`ch`, `fr`, `us` : votre réglage `gsettings` est conservé), l'écran qui
   ne se verrouille pas, le dock (Terminal, VS Code, Firefox, Fichiers).
3. Faites le parcours d'installation du jour 1 après-midi avec **une clé de test** et **un
   compte GitHub de test**, jusqu'à la fenêtre du tuteur. Ouvrez Firefox pour `gh auth login`.

### Étape 4 — Nettoyer et fermer (≈ 5 min)

```bash
sudo bash 3-seal.sh               # à blanc : liste ce qui sera effacé, n'efface rien
sudo bash 3-seal.sh --apply       # efface
```

- Lisez la liste à blanc avant `--apply`.
- Si vous vous êtes connecté à GitHub (ou à un autre site) dans Firefox pendant le test :
  ajoutez `--reset-browser`.
- Si une application a enregistré un mot de passe (trousseau GNOME) : ajoutez `--reset-keyrings`.
  Sans test de connexion, n'utilisez pas ces deux options.
- Une ligne `!` « defines OPENROUTER_API_KEY » (ou autre secret) dans `.bashrc` : supprimez
  cette ligne à la main ; le script ne modifie pas ces fichiers et n'affiche jamais la valeur.

Puis contrôlez, et éteignez **sans vous reconnecter** :

```bash
bash 4-verify.sh                  # tout doit être ✓ (les lignes · sont informatives)
sudo poweroff
```

Si vous vous reconnectez après le nettoyage, un nouvel historique est créé : relancez
`3-seal.sh --apply`.

### Étape 5 — Créer les copies et vérifier une copie

1. Transformez la VM en modèle et créez les instances avec l'outil de la plateforme.
2. Sur **deux** copies : `bash ~/vm-template/4-verify.sh --clone`. Les identifiants de machine
   affichés doivent être **différents** (sinon les copies risquent de recevoir la même adresse réseau).
3. Le dossier `~/vm-template` peut rester sur les copies : il ne contient aucun secret.

## Ce qui reste à faire par chaque participant

- sa clé de modèle : `opencode auth login` (étape 3) ;
- sa connexion GitHub et son identité git : `gh auth login`, `git config --global user.name/email` (étape 6) ;
- s'il n'y a pas de pré-installation : opencode, le kit, GSE-One (étapes 1, 4, 5).

À la fin du cours, si les machines sont réutilisées par d'autres personnes : recréez-les à
partir du modèle plutôt que de les nettoyer (leurs clés et connexions y sont).

## VS Code ou VSCodium ?

Les diapositives et le mini guide `syllabus/ide-guide.md` parlent de VSCodium sur les machines
personnelles. Dans la VM, VS Code est déjà installé : avec les réglages de `1-system.sh`, son IA
est coupée de la même façon (`chat.disableAIFeatures`). Dites simplement aux participants :
« sur la VM, c'est VS Code, son IA est déjà coupée ».

## Répéter sur un Mac (VM locale)

Pour répéter le modèle sur un Mac Apple Silicon, sans serveur : `bash local-vm/setup-mac-vm.sh`
(`--dry-run` pour voir ce qu'il ferait, `--with-tailscale` pour l'accès depuis vos autres appareils).
Il installe ce qui manque (Homebrew, VirtualBox, Tailscale en option), refuse un dossier de VM dans
Dropbox ou iCloud (`~/VMs` par défaut), puis lance `local-vm/create-local-vm.sh` (≈ 25 min).
Connexion ensuite avec Windows App : `localhost:3390`, utilisateur `student`, session Xorg.

Au quotidien, `bash local-vm/vm.sh` règle les situations courantes sans réfléchir : `status`, `start`,
`stop`, `restart`, `fix-rdp` (écran gris ou noir dans Windows App), `diag` (diagnostic complet à coller à
Claude), `ssh`, et les instantanés : `snap [nom]`, `snaps`, `restore <nom>`, `snap-delete <nom>`.
Prenez un instantané après chaque étape réussie (`bash local-vm/vm.sh snap apres-etape-4`) : VirtualBox
sur Mac Apple Silicon reste fragile, et une restauration prend une minute.
