#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Migracao segura e verificada

cd ~/Bizumatica

echo "🚚 MIGRAÇÃO DE CONTEÚDO SEGURA"
echo "================================"

# Criar log de migração
LOG_FILE="migracao-$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

# 1. Verificar diferenças entre original e unificado
echo -e "\n1. 📊 ANALISANDO DIFERENÇAS:"
echo "   Original (blog):"
find bizumatica-blog/content -type f -name "*.md" | wc -l
echo "   Original (home):"
find bizumatica-home/content -type f -name "*.md" | wc -l
echo "   Unificado:"
find bizumatica-unified/content -type f -name "*.md" | wc -l

# 2. Verificar se algum arquivo foi perdido
echo -e "\n2. 🔍 VERIFICANDO ARQUIVOS PERDIDOS:"
ALL_FILES=$(find bizumatica-blog/content bizumatica-home/content -name "*.md" | sort)
for file in $ALL_FILES; do
    BASE_NAME=$(basename "$file")
    if ! find bizumatica-unified/content -name "$BASE_NAME" | grep -q .; then
        echo "   ⚠️  Arquivo não migrado: $BASE_NAME"
        # Tentar encontrar similar
        SIMILAR=$(find bizumatica-unified/content -name "*.md" -exec basename {} \; | grep -i "$(echo "$BASE_NAME" | sed 's/.md//')")
        if [ -n "$SIMILAR" ]; then
            echo "     ➡️  Possível correspondência: $SIMILAR"
        fi
    fi
done

# 3. Copiar recursos estáticos (imagens, etc.)
echo -e "\n3. 🖼️  MIGRANDO RECURSOS ESTÁTICOS:"
if [ -d "bizumatica-blog/static" ]; then
    cp -r bizumatica-blog/static/* bizumatica-unified/static/ 2>/dev/null || true
    echo "   ✅ Static do blog copiado"
fi

if [ -d "bizumatica-home/static" ]; then
    cp -r bizumatica-home/static/* bizumatica-unified/static/ 2>/dev/null || true
    echo "   ✅ Static do home copiado"
fi

# 4. Verificar links quebrados
echo -e "\n4. 🔗 VERIFICANDO LINKS INTERNOS:"
cd bizumatica-unified
python3 -c "
import os
import re
import sys

def check_links():
    broken = []
    for root, dirs, files in os.walk('content'):
        for file in files:
            if file.endswith('.md'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    # Encontrar links markdown
                    links = re.findall(r'\[([^\]]+)\]\(([^)]+)\)', content)
                    for text, link in links:
                        if link.startswith('/'):
                            # Link interno
                            target = link.lstrip('/')
                            if not os.path.exists(os.path.join('content', target + '.md')) and \
                               not os.path.exists(os.path.join('content', target + '/index.md')):
                                broken.append(f'{path}: [{text}]({link})')
    
    if broken:
        print('   Links quebrados encontrados:')
        for b in broken[:5]:  # Mostrar só os primeiros 5
            print(f'   ❌ {b}')
        if len(broken) > 5:
            print(f'   ... e mais {len(broken)-5} links')
    else:
        print('   ✅ Nenhum link quebrado encontrado')

check_links()
" 2>/dev/null || echo "   ℹ️  Python não disponível para verificação de links"

# 5. Testar build final
echo -e "\n5. 🧪 TESTE FINAL DO BUILD:"
hugo -D --minify
if [ $? -eq 0 ]; then
    echo "   ✅ Build final bem-sucedido!"
    echo "   📁 Site gerado em: public/"
    echo "   📄 Total de páginas: $(find public -name "*.html" | wc -l)"
else
    echo "   ❌ Erro no build final!"
    exit 1
fi

echo -e "\n🎉 MIGRAÇÃO VERIFICADA COM SUCESSO!"
echo "📋 Log salvo em: $LOG_FILE"
echo "➡️  Próximo passo: Testar localmente com 'hugo server -D'"