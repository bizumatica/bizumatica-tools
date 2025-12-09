# monitor-deploy.sh
#!/bin/bash
echo "📊 MONITORAMENTO PÓS-DEPLOY"
echo "==========================="

# Verificar se site está online
echo -e "\n1. 🌐 Verificando status online..."
for i in {1..10}; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://bizumatica.github.io)
    if [ "$STATUS" = "200" ]; then
        echo "   ✅ Site online (HTTP 200)"
        break
    else
        echo "   ⏳ Tentativa $i/10: HTTP $STATUS"
        sleep 10
    fi
done

# Testar páginas críticas
echo -e "\n2. 🔗 Testando páginas críticas..."
PAGINAS_CRITICAS=(
    "/"
    "/posts/"
    "/about/"
    "/paginas/shell-scripting-automacao/"
)

for pagina in "${PAGINAS_CRITICAS[@]}"; do
    URL="https://bizumatica.github.io$pagina"
    if curl -s -f "$URL" > /dev/null; then
        echo "   ✅ $pagina"
    else
        echo "   ❌ $pagina (falha)"
    fi
done

# Verificar console errors
echo -e "\n3. 🐛 Verificando erros no console..."
# Usando puppeteer via node ou simples curl
curl -s https://bizumatica.github.io | grep -o "error\|Error\|ERROR" | head -5

echo -e "\n📈 MONITORAMENTO CONCLUÍDO"