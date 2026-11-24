# Manuel du conseiller — suivre et conseiller les projets des participants

Pour le formateur (ou tout expert externe). Tu **conseilles**, le participant **décide** : tu n'écris jamais
dans son dépôt. Ton seul moyen d'agir est un **ticket de conseil** : un ticket GitHub (issue) avec l'étiquette
`gse-advisor`, ouvert sur son dépôt. GSE-One (v0.93.4 et suivantes) le lui présente quand il ouvre son sprint
suivant (`/gse-plan`) : il l'**accepte** dans le sprint, le **garde** pour plus tard, ou le **refuse** avec une
raison. GSE-One écrit sa décision dans le ticket : tu la lis depuis GitHub, sans ouvrir ses fichiers.

Chaque commande est seule dans son bloc, à coller dans le Terminal **de ton Mac**. Les noms entre `<…>` sont à
remplacer. Les outils sont dans `~/ai4se/ai4se-kit/trainer/` (ou le dossier `trainer` du kit sur tes Mac).

## 1. Comment ça marche, en une minute

| Étape | Qui | Quoi |
|---|---|---|
| 1 | Toi | `advisor.py` lit ce que chaque participant a **poussé** sur GitHub et fait une page HTML : une ligne par projet, les alertes en premier |
| 2 | Toi + ton agent (Claude Code ou opencode) | l'agent inspecte un projet **en lecture seule** et te propose au plus 3 conseils |
| 3 | Toi | tu gardes, modifies ou refuses chaque conseil |
| 4 | Ton agent | il crée seulement les tickets que tu as acceptés (`gse-advisor`) |
| 5 | Le participant | à l'ouverture de son sprint suivant, GSE-One lui pose **une seule question** pour tous tes tickets : accepter / garder / refuser avec une raison |
| 6 | GSE-One | il répond dans chaque ticket ; refusé → fermé tout de suite ; accepté → fermé quand la tâche est livrée |
| 7 | Toi | `advisor_tickets.py list` montre chaque ticket et la décision |

Délai : ton conseil est étudié **au prochain sprint** du participant, pas en plein sprint (il ne casse pas
son travail en cours). Un ticket ouvert pendant le sprint 2 est vu à l'ouverture du sprint 3.

## 2. Une seule fois, avant la formation

Te connecter à GitHub avec `gh` (pour lire les dépôts privés et ouvrir les tickets) :

```bash
gh auth login
```

Vérifier :

```bash
gh auth status
```

Créer ton dossier **privé** (hors de tout dépôt et hors Dropbox : la liste contient des noms) :

```bash
mkdir -p ~/ai4se-conseil
```

Copier le modèle de liste des participants :

```bash
cp ~/ai4se/ai4se-kit/trainer/roster.example.csv ~/ai4se-conseil/roster.csv
```

Le remplir (une ligne par dépôt ; un participant avec CalcApp et un mini-projet a deux lignes) :

```bash
open -e ~/ai4se-conseil/roster.csv
```

Colonnes : `id` (v01, v02… comme la feuille de suivi), `name` (pour toi seul), `repo` (`compte/depot` ou
adresse GitHub), `project` (facultatif), `url` (adresse de l'application en ligne, facultatif).

**Accès aux dépôts.** CalcApp est public (rien à faire). Un mini-projet **privé** doit t'inviter :
GitHub → Settings → Collaborators → `nicolasguelfi` (la fiche hd08 le demande aux participants).
Accepte les invitations reçues par e-mail ou sur github.com/notifications.

Préparer le dossier pour ton agent de codage (Claude Code, opencode, Codex ou Gemini) :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py session --roster ~/ai4se-conseil/roster.csv
```

Cela écrit `AGENTS.md`, `CLAUDE.md` et `GEMINI.md` dans `~/ai4se-conseil/` : ton agent y lit la procédure
`trainer/ADVISOR-SESSION.md` (lecture seule, au plus 3 tickets par projet, ton accord avant chaque ticket).

## 3. Pendant la formation — à chaque pause ou demi-journée

Demander aux participants de **pousser** leur travail (le tableau ne voit que ce qui est poussé) :
« `git push` avant la pause ».

Rafraîchir le tableau de bord :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor.py --roster ~/ai4se-conseil/roster.csv
```

L'ouvrir :

```bash
open ~/ai4se-conseil/advisor.html
```

Les alertes à regarder d'abord : rien poussé depuis longtemps, tâches produites sans preuve de test, tests en
échec, constats de revue ouverts, budget dépassé, `.gse/` ignoré par git, dépôt illisible, application en
ligne qui ne répond pas.

Lancer ton agent dans ton dossier privé (au choix) :

```bash
cd ~/ai4se-conseil && claude
```

```bash
cd ~/ai4se-conseil && opencode
```

Puis lui dire simplement, par exemple :
« Inspecte le projet de v03 (calcapp) et propose-moi des tickets de conseil. »
L'agent lit le projet sans rien y écrire, te présente ses propositions (problème, preuve, pourquoi c'est
important, suggestion), et attend ton choix. Il crée seulement ceux que tu gardes.

**Bons conseils** (ce que l'agent vise) : au plus 3 par projet et par passage ; un problème par ticket ;
une preuve précise (fichier et ligne, commit, champ de `.gse/`) ; en anglais, langue du cours. Deux sortes :
*produit* (bug, test manquant, exigence non tenue) et *méthode* (revue sautée, tests déclarés mais absents,
décision non tracée, sprint trop gros).

Créer un ticket **à la main**, sans agent — écrire le texte dans un fichier, puis essai à blanc :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py create --repo <compte/depot> --title "<titre>" --body-file <fichier.md> --dry-run
```

Puis pour de vrai :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py create --repo <compte/depot> --title "<titre>" --body-file <fichier.md>
```

## 4. Suivre les décisions

Tous tes tickets et la décision de chaque participant :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py list --roster ~/ai4se-conseil/roster.csv
```

Un seul dépôt :

```bash
python3 ~/ai4se/ai4se-kit/trainer/advisor_tickets.py list --repo <compte/depot>
```

Lecture : « not studied yet » = le participant n'a pas encore ouvert de nouveau sprint ; un commentaire
« Accepted / Kept / Declined … (GSE-One) » = sa décision et sa raison. Un refus argumenté est un bon
résultat : c'est le participant qui décide. Pour en discuter, réponds dans le ticket ou en salle.

## 5. Ce que voit le participant

À l'ouverture de son sprint suivant, GSE-One récupère tes tickets et lui pose **une seule question** pour
tous : pour chacun, accepter dans ce sprint / garder pour plus tard / refuser avec une raison d'une ligne.
Chaque décision est notée dans son journal (`.gse/decisions.md`, DEC-…). Il n'y a aucune question s'il n'y
a pas de ticket. Sans dépôt GitHub ou sans `gh` connecté chez lui, l'étape est sautée avec une ligne
d'information (le ticket attend le sprint suivant).

## 6. Problèmes fréquents

| Symptôme | Que faire |
|---|---|
| Une ligne du tableau dit « cannot read the repository » | dépôt privé sans invitation, ou adresse fausse dans `roster.csv` |
| Le tableau ne montre pas le travail du jour | le participant n'a pas poussé : `git push` |
| `create` échoue : droits insuffisants | dépôt privé : il faut l'invitation comme collaborateur |
| Le participant n'a jamais vu tes tickets | il n'a pas encore ouvert de nouveau sprint, ou son `gh` n'est pas connecté (`gh auth status` chez lui) ; ou son GSE-One est antérieur à 0.93.4 (`tutor version`) |
| Un ticket reste ouvert après « Accepted » | normal : il se ferme quand la tâche correspondante est livrée (`/gse-deliver`) |

## 7. Confidentialité et fin de formation

- `roster.csv` et `advisor.html` contiennent des noms : ils restent dans ton dossier privé, jamais dans un dépôt.
- Les tickets sont visibles par quiconque voit le dépôt (public pour CalcApp) : n'y mets ni nom, ni note, ni
  jugement personnel — uniquement le problème technique ou de méthode.
- Les copies des dépôts (`~/ai4se-conseil/.advisor-cache/`) ont le push désactivé ; supprime ce dossier
  après la formation.

Documentation technique (anglais) : [`README.md`](README.md). Procédure suivie par l'agent :
[`ADVISOR-SESSION.md`](ADVISOR-SESSION.md).
