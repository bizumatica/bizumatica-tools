# BackInBash Tools

Ferramentas de backup escritas em Bash para automatizar tarefas de cópia, sincronização e versionamento de dados.

## 📋 Descrição

Este repositório contém uma coleção de scripts Bash para facilitar operações de backup em ambientes Linux/Unix. As ferramentas são projetadas para serem leves, modulares e fáceis de usar.

## 🚀 Funcionalidades

- **Backup incremental/diferencial**
- **Sincronização com servidores remotos**
- **Compactação e criptografia de dados**
- **Agendamento automático de backups**
- **Logging e notificações**
- **Restauração simplificada**

## 📦 Instalação

```bash
# Clone o repositório
git clone https://github.com/bizumatica/backinbash-tools.git

# Acesse o diretório
cd backinbash-tools

# Dê permissão de execução aos scripts
chmod +x scripts/*.sh
```

## 🛠️ Configuração

1. Copie o arquivo de configuração de exemplo:
```bash
cp config/exemplo.conf config/meu-backup.conf
```

2. Edite o arquivo de configuração com suas preferências:
```bash
nano config/meu-backup.conf
```

## 📖 Uso Básico

```bash
# Executar backup simples
./scripts/backup.sh -c config/meu-backup.conf

# Verificar status dos backups
./scripts/status.sh

# Restaurar backup
./scripts/restore.sh -d /caminho/restauracao -b backup_20240121
```

## 🗂️ Estrutura do Projeto

```
backinbash-tools/
├── scripts/           # Scripts principais
├── config/            # Arquivos de configuração
├── docs/              # Documentação
├── tests/             # Testes automatizados
├── logs/              # Logs de execução (gerado)
└── README.md          # Este arquivo
```

## 🔧 Dependências

- Bash 4.0+
- rsync
- tar
- gzip/bzip2
- openssl (para criptografia)
- mailx ou sendmail (para notificações por email)

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## ⚠️ Aviso

Estas ferramentas são fornecidas "como estão", sem garantias. Sempre teste seus backups e certifique-se de que está seguindo as melhores práticas de backup para seu ambiente.

## 📞 Suporte

Se encontrar problemas ou tiver sugestões:
- [Abra uma issue](https://github.com/bizumatica/backinbash-tools/issues)
- Verifique a documentação na pasta `docs/`

---

**⭐ Se este projeto foi útil, considere dar uma estrela no repositório!**

*Desenvolvido com ❤️ pela comunidade open source.*