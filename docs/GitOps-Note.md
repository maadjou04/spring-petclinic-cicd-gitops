# Note GitOps — TP4 CI/CD & GitOps

## 1. Qu'est-ce que GitOps ?

Le GitOps est une approche de déploiement continu où **tout le système est décrit dans Git**. Le dépôt Git devient la **source unique de vérité** pour l'infrastructure et l'application.

### Principes fondamentaux :
- **Déclaratif** : l'état désiré est décrit dans des fichiers (Terraform, Kubernetes)
- **Versionné** : chaque changement est enregistré dans Git
- **Automatique** : le pipeline applique automatiquement l'état déclaré
- **Auto-réconciliateur** : le système corrige toute dérive

## 2. Flux GitOps mis en œuvre dans ce TP

### Pull Request (PR) → Planification
1. Le développeur crée une PR avec ses modifications
2. Le pipeline exécute `terraform plan` automatiquement
3. L'impact des changements est visible dans la PR
4. La PR est validée par le binôme

### Merge sur main → Application
1. La PR est fusionnée dans `main`
2. Le pipeline exécute `terraform apply` automatiquement
3. L'infrastructure est mise à jour
4. L'application est déployée

### Rollback = Git revert
1. Un bug est détecté en production
2. On exécute `git revert <commit>`
3. Le pipeline se déclenche et restaure la version précédente
4. L'infrastructure est réconciliée
