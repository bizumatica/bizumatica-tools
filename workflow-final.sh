# workflow-final.sh
#!/bin/bash
echo "🔧 FLUXO DE TRABALHO COMPLETO"
echo "=============================="

echo -e "\n1. 🧹 Limpar e preparar:"
cd ~/Bizumatica/bizumatica-unified
git status
read -p "   Continuar? (s/N): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Ss]$ ]] && exit 0

echo -e "\n2. 🧪 Testar localmente:"
hugo server -D &
SERVER_PID=$!
sleep 2
xdg-open http://localhost:1313 2>/dev/null || echo "   Acesse: http://localhost:1313"
read -p "   Site OK? Pressione Enter para continuar..." -n 1
kill $SERVER_PID

echo -e "\n3. 🚀 Deploy seguro:"
./deploy-seguro.sh

echo -e "\n4. 📊 Monitorar:"
sleep 60  # Esperar GitHub Pages
./monitor-deploy.sh

echo -e "\n🎉 PROCESSO CONCLUÍDO!"
echo "🌐 Site: https://bizumatica.github.io"
echo "📁 Backup disponível em: ~/Bizumatica/backup-deploy/"