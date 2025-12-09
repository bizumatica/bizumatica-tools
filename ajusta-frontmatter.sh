#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Ajusta frontmatter

cd ~/Bizumatica/bizumatica-unified

for arquivo in content/paginas/*.md; do
    if [ -f "$arquivo" ]; then
        # Extrair título do nome do arquivo
        TITULO=$(basename "$arquivo" .md | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')
        
        # Verificar se já tem front matter
        if ! head -1 "$arquivo" | grep -q "---"; then
            # Adicionar front matter básico
            cat > "$arquivo.tmp" << EOF
---
title: "$TITULO"
date: $(date +%Y-%m-%d)
draft: false
type: page
menu:
  main:
    weight: 50
---
EOF
            cat "$arquivo" >> "$arquivo.tmp"
            mv "$arquivo.tmp" "$arquivo"
            echo "✅ Front matter adicionado: $arquivo"
        else
            # Atualizar tipo para page
            sed -i 's/^type: .*/type: page/' "$arquivo" 2>/dev/null || true
            if ! grep -q "type: page" "$arquivo"; then
                # Inserir após o primeiro ---
                sed -i '/^---$/a type: page' "$arquivo"
            fi
        fi
    fi
done