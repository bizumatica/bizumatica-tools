#!/bin/bash

# Author: Julio Prata
# Created: 15 dez 2025
# Last Modified: 15 dez 2025
# Version: 1.0
# Usage: ./validar-links.sh [arquivo] (Padrão: ../README.md)

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Define qual arquivo verificar (Padrão: README na raiz do monorepo)
ARQUIVO="${1:-../README.md}"

echo -e "${CYAN}--- Iniciando Validação de Links em: $ARQUIVO ---${NC}"

if [ ! -f "$ARQUIVO" ]; then
    echo -e "${RED}Erro: Arquivo $ARQUIVO não encontrado.${NC}"
    exit 1
fi

# Extrai links HTTP/HTTPS (Ignora links locais ou relativos por enquanto)
# A Regex procura por strings que começam com http(s) e vão até fechar parênteses ou espaço
LINKS=$(grep -oP 'https?://[^)\s"]+' "$ARQUIVO" | sort | uniq)

if [ -z "$LINKS" ]; then
    echo -e "${YELLOW}Nenhum link externo encontrado.${NC}"
    exit 0
fi

ERROS=0

for url in $LINKS; do
    # Faz uma requisição HEAD (mais leve que baixar a página toda)
    # -L: Segue redirecionamentos
    # --fail: Retorna erro se o código for 400+
    # User-Agent: Finge ser um browser para evitar bloqueios de bot
    if curl --head --silent --fail -L -A "Mozilla/5.0" "$url" > /dev/null; then
        echo -e "[${GREEN}OK${NC}] $url"
    else
        echo -e "[${RED}FALHA${NC}] $url"
        ((ERROS++))
    fi
done

echo -e "${CYAN}------------------------------------------------${NC}"

if [ $ERROS -eq 0 ]; then
    echo -e "${GREEN}✅ Sucesso! Todos os links estão ativos.${NC}"
    exit 0
else
    echo -e "${RED}❌ Atenção: $ERROS link(s) quebrado(s) encontrado(s).${NC}"
    # O exit 1 é útil se você quiser impedir o commit automático caso haja erro
    exit 1
fi