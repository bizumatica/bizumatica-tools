#!/bin/bash

# Author: Julio Prata
# Created: 15 dez 2025
# Last Modified: 15 dez 2025
# Version: 1.0
# Description: Administra versionamento do source hub.

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Versão para: $PROJECT_NAME (HUB de Gestão) ---${NC}"

# 1. Captura a mensagem de commit (ou usa um padrão)
msg="Update $(date)"
if [ $# -eq 1 ]; then
    msg="$1"
fi

# 2. Verifica se há mudanças.
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para commitar. O diretório está limpo.${NC}"
    exit 0
fi

# 3. Adiciona APENAS os arquivos de gestão (excluindo qualquer .gitignore acidental)
echo -e "${GREEN}--> Versionando arquivos de Gestão...${NC}"
git add .
# Uma verificação extra para garantir que os sites não sejam incluídos (já coberto pelo .gitignore)
git add .gitignore README.md bizumatica-logo.png fluxo-reg.mmd bizumatica-tools

# 4. Commita e Envia
echo -e "${GREEN}--> Enviando para o GitHub (bizumatica-source)...${NC}"
git commit -m "update: $msg (Hub Versionamento)"
git push origin main

echo -e "${CYAN}--- Versão do $PROJECT_NAME concluída com sucesso! ---${NC}"