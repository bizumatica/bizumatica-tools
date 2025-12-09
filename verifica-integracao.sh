#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: verificao de integridade

echo "🔍 VERIFICAÇÃO DE INTEGRIDADE"
echo "=============================="

cd ~/Bizumatica/bizumatica-unified

# 1. Verificar se todos os arquivos .md têm front matter válido
echo -e "\n1. Front Matter dos arquivos:"
for md in content/**/*.md; do
    if [ -f "$md" ]; then
        if head -1 "$md" | grep -q "---"; then
            echo "  ✅ $md"
        else
            echo "  ❌ $md (sem front matter)"
        fi
    fi
done

# 2. Verificar links no menu
echo -e "\n2. Links do menu:"
grep -A2 "\[\[menu.main\]\]" hugo.toml | grep "url = "

# 3. Verificar se arquivos existem
echo -e "\n3. Existência dos arquivos referenciados:"
grep "url = \"" hugo.toml | while read line; do
    URL=$(echo "$line" | sed 's/.*url = "\([^"]*\)".*/\1/')
    # Remover / no início
    PATH_FILE="${URL:1}index.md"
    if [ -f "content/$PATH_FILE" ]; then
        echo "  ✅ $URL → content/$PATH_FILE"
    else
        echo "  ⚠️  $URL (não encontrado, pode ser página gerada)"
    fi
done

# 4. Verificar temas/terminal existe
echo -e "\n4. Tema Terminal:"
if [ -d "themes/terminal" ]; then
    echo "  ✅ Tema encontrado"
else
    echo "  ❌ Tema não encontrado!"
fi

echo -e "\n📊 RESUMO:"
echo "Arquivos .md: $(find content -name "*.md" | wc -l)"
echo "Páginas: $(find content/paginas -name "*.md" | wc -l)"
echo "Posts: $(find content/posts -name "*.md" | wc -l)"