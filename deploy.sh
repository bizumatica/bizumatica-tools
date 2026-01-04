#!/bin/bash

# Author: Julio Prata
# Created: 01 dez 2025
# Last Modified: 08 dez 2025
# Version: 2.0 - Híbrido com Auto-Tagging
# Description: Deploy para Hugo (Cloudflare) e Ferramentas (GitHub)

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")
echo -e "${CYAN}--- Iniciando Deploy: $PROJECT_NAME ---${NC}"

# 1. IDENTIFICAÇÃO DO TIPO DE PROJETO
IS_HUGO=false
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    IS_HUGO=true
fi

# 2. EXECUÇÃO DO BUILD (Apenas para Hugo)
if [ "$IS_HUGO" = true ]; then
    echo -e "${GREEN}--> [HUGO] Site detectado. Gerando build em /docs...${NC}"
    if HUGO_ENV=production hugo --minify --cleanDestinationDir -d docs; then
        echo -e "${GREEN}--> Build OK!${NC}"
    else
        echo -e "${RED}--> ERRO no Hugo. Abortando.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}--> [TOOLS] Repositório de ferramentas detectado.${NC}"
fi

# 3. GIT - COMMIT
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para alterar. O diretório está limpo.${NC}"
    exit 0
fi

msg="Update $(date +'%d/%m/%Y %H:%M')"
if [ $# -eq 1 ]; then msg="$1"; fi

git add .
git commit -m "$msg ($PROJECT_NAME)"

# 4. GESTÃO DE VERSÃO (TAGS)
# Pega a última tag ou começa em v0.0.0
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
# Incrementa o último número (Patch)
NEW_TAG=$(echo $LAST_TAG | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')

echo -e "${CYAN}--> Criando versão $NEW_TAG...${NC}"
git tag -a "$NEW_TAG" -m "Versão automática: $NEW_TAG"

# 5. PUSH FINAL (Arquivos + Tags)
echo -e "${GREEN}--> Enviando para o GitHub...${NC}"
if git push origin main && git push origin "$NEW_TAG"; then
    echo -e "${GREEN}--- OK: $PROJECT_NAME atualizado para $NEW_TAG ---${NC}"
else
    echo -e "${RED}--- ERRO no Push. Verifique conexão ou permissões. ---${NC}"
    exit 1
fi