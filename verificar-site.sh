#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Verifica site

cd ~/Bizumatica/bizumatica-unified

echo "🧪 TESTANDO SITE UNIFICADO"
echo "=========================="

# 1. Iniciar servidor em background
hugo server -D --port 1818 > /tmp/hugo-test.log 2>&1 &
HUGO_PID=$!
sleep 3  # Dar tempo para iniciar

# 2. Testar endpoints básicos
echo -e "\n🔗 Testando URLs:"
URLS=(
    "http://localhost:1818/"
    "http://localhost:1818/posts/"
    "http://localhost:1818/about/"
    "http://localhost:1818/paginas/shell-scripting-automacao/"
    "http://localhost:1818/paginas/o-ecossistema-linux/"
)

for url in "${URLS[@]}"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$STATUS" = "200" ]; then
        echo "  ✅ $url (HTTP $STATUS)"
    else
        echo "  ❌ $url (HTTP $STATUS)"
    fi
done

# 3. Verificar se posts aparecem
echo -e "\n📝 Verificando posts:"
POST_COUNT=$(curl -s http://localhost:1818/posts/ | grep -c "post-title\|post-list")
echo "  Posts encontrados: $POST_COUNT"

# 4. Verificar menu
echo -e "\n🍔 Verificando menu:"
MENU_ITEMS=$(curl -s http://localhost:1818/ | grep -c "menu-item\|nav-link")
echo "  Itens de menu: $MENU_ITEMS"

# 5. Parar servidor
kill $HUGO_PID 2>/dev/null

# 6. Verificar build de produção
echo -e "\n🏗️  Testando build de produção:"
rm -rf public-test
hugo -D -d public-test

if [ $? -eq 0 ]; then
    echo "  ✅ Build de produção bem-sucedido"
    echo "  📁 Gerado em: public-test/"
    echo "  📄 Arquivos HTML: $(find public-test -name "*.html" | wc -l)"
else
    echo "  ❌ Erro no build de produção"
fi

echo -e "\n📊 RESUMO:"
echo "Conteúdo total: $(find content -name "*.md" | wc -l) arquivos .md"
echo "Páginas: $(find content/paginas -name "*.md" | wc -l)"
echo "Posts: $(find content/posts -name "*.md" | wc -l)"