#!/bin/bash

# Author: Julio Prata
# Created: 09 dez 2025
# Last Modified: 09 dez 2025
# Version: 1.0
# Description: Deploy seguro para uniicação do Site e Blog

cd ~/Bizumatica/bizumatica-unified

echo "🚀 DEPLOY SEGURO PARA GITHUB PAGES"
echo "=================================="

# 1. Gerar site
echo -e "\n1. 🏗️  Gerando site..."
hugo -D --minify

# 2. Verificar se há diferenças com o atual
echo -e "\n2. 🔍 Comparando com produção atual..."
if [ -d "../bizumatica-blog/docs" ]; then
    diff -qr public ../bizumatica-blog/docs | head -20
    echo "   Total de diferenças: $(diff -qr public ../bizumatica-blog/docs | wc -l)"
fi

# 3. Backup do deploy atual
echo -e "\n3. 💾 Criando backup..."
BACKUP_DIR="../backup-deploy/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
if [ -d "../bizumatica-blog/docs" ]; then
    cp -r ../bizumatica-blog/docs/* "$BACKUP_DIR/"
    echo "   Backup salvo em: $BACKUP_DIR"
fi

# 4. Perguntar confirmação
read -p "4. ❓ Continuar com deploy? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "   ⏹️  Deploy cancelado"
    exit 0
fi

# 5. Deploy em 3 etapas
echo -e "\n5. 📤 Realizando deploy..."
echo "   Fase 1: Preparando docs/"
rm -rf docs
cp -r public docs

echo "   Fase 2: Commit..."
git add docs/
git commit -m "Deploy seguro $(date '+%Y-%m-%d %H:%M:%S')"

echo "   Fase 3: Push..."
git push origin $(git branch --show-current)

# 6. Verificar deploy
echo -e "\n6. ✅ Deploy concluído!"
echo "   🌐 Site: https://bizumatica.github.io"
echo "   ⏱️  Aguarde 1-2 minutos para o GitHub Pages atualizar"
echo "   🔄 Status: https://github.com/bizumatica/bizumatica.github.io/deployments"

# 7. Script de rollback rápido
cat > ../rollback-rapido.sh << 'EOF'
#!/bin/bash
# Rollback rápido para o último backup
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
EOF
chmod +x ../rollback-rapido.sh
echo "   🆘 Rollback rápido: ./rollback-rapido.sh"