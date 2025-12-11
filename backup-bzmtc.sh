#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 10 dez 2025
# Version: 1.1
# Description: Cria backup completo com timestamp

DIR_ORIGEM="$HOME/Bizumatica"
DATA_BACKUP=$(date +%Y%m%d_%H%M%S)
DIR_BACKUP="$HOME/backup-bizumatica/$DATA_BACKUP"

mkdir -p "$DIR_BACKUP"

# 1. Backup dos sites originais (usando caminhos absolutos)
cp -r "$DIR_ORIGEM"/bizumatica-blog "$DIR_BACKUP"/
cp -r "$DIR_ORIGEM"/bizumatica-home "$DIR_BACKUP"/
cp -r "$DIR_ORIGEM"/bizumatica-tools "$DIR_BACKUP"/

# 2. Backup do repositório git
if [ -d "$DIR_ORIGEM/.git" ]; then
    (cd "$DIR_ORIGEM" && git bundle create "$DIR_BACKUP/repo-backup.bundle" --all)
fi

# 3. Verificar backup
echo "✅ Backup criado em: $DIR_BACKUP"
ls -la "$DIR_BACKUP/"