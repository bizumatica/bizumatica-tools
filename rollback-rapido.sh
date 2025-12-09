#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Rollback rapido para o ultimo backup

cd ~/Bizumatica
LATEST=$(ls -td backup-deploy/* | head -1)
if [ -n "$LATEST" ] && [ -d "$LATEST" ]; then
    echo "Revertendo para backup: $LATEST"
    rm -rf bizumatica-blog/docs
    cp -r "$LATEST" bizumatica-blog/docs
    cd bizumatica-blog
    git add docs/
    git commit -m "ROLLBACK: $(date)"
    git push
    echo "Rollback concluído!"
else
    echo "Nenhum backup encontrado!"
fi
