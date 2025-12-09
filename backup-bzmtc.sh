#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Cria backup completo com timestamp

cd ~/Bizumatica
DATA_BACKUP=$(date +%Y%m%d_%H%M%S)
mkdir -p ~/backup-bizumatica/$DATA_BACKUP

# 1. Backup dos sites originais
cp -r bizumatica-blog ~/backup-bizumatica/$DATA_BACKUP/
cp -r bizumatica-home ~/backup-bizumatica/$DATA_BACKUP/
cp -r bizumatica-tools ~/backup-bizumatica/$DATA_BACKUP/

# 2. Backup do repositório git (se aplicável)
if [ -d .git ]; then
    git bundle create ~/backup-bizumatica/$DATA_BACKUP/repo-backup.bundle --all
fi

# 3. Verificar backup
echo "✅ Backup criado em: ~/backup-bizumatica/$DATA_BACKUP"
ls -la ~/backup-bizumatica/$DATA_BACKUP/