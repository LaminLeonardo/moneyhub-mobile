# MoneyHub Mobile

[![CI](https://github.com/LaminLeonardo/moneyhub-mobile/actions/workflows/ci.yml/badge.svg)](https://github.com/LaminLeonardo/moneyhub-mobile/actions/workflows/ci.yml)
[![CD](https://github.com/LaminLeonardo/moneyhub-mobile/actions/workflows/cd.yml/badge.svg)](https://github.com/LaminLeonardo/moneyhub-mobile/actions/workflows/cd.yml)

Cliente **Flutter** do **MoneyHub**, aplicativo de finanças pessoais (saldo, receitas, despesas e lançamentos).
Este repositório é o projeto de desenvolvimento descrito no
**PGCS — Plano de Gerenciamento de Configuração de Software** ([docs/pgcs](docs/pgcs)), com enfoque DevOps (CI/CD).

| Ambiente | URL | Como é atualizado |
|---|---|---|
| Homologação | https://laminleonardo.github.io/moneyhub-mobile/staging/ | Automaticamente a cada merge na `main` |
| Produção | https://laminleonardo.github.io/moneyhub-mobile/ | Após a release + aprovação manual (gate) |
| Imagem Docker | `ghcr.io/laminleonardo/moneyhub-mobile:<versão>` | Publicada pelo CD |
| APK Android | Aba [Releases](https://github.com/LaminLeonardo/moneyhub-mobile/releases) | Anexado a cada release |

## Estrutura do repositório

```
.
├── .github/
│   ├── workflows/          # Pipelines como código: ci.yml, cd.yml, rollback.yml, iac.yml, labels.yml
│   ├── ISSUE_TEMPLATE/     # Solicitação de Mudança (SM) e Relato de Defeito
│   ├── pull_request_template.md
│   ├── labels.yml          # Labels como código (status da SM, tipo, prioridade, CCM)
│   ├── dependabot.yml      # Atualização automática de dependências
│   └── CODEOWNERS
├── mobile/                 # Aplicativo Flutter
│   ├── lib/                #   código-fonte (models, services, screens, config)
│   ├── test/               #   testes unitários, de widget e de integração
│   ├── Dockerfile          #   imagem web (nginx) com o build já compilado
│   ├── pubspec.yaml        #   dependências + versão (SemVer)
│   └── CHANGELOG.md        #   gerado pelo release-please
├── infra/terraform/        # IaC: repositório, proteção da main e ambientes no GitHub
├── scripts/                # check_coverage.sh (quality gate) e smoke_test.sh
├── docs/                   # PGCS, onboarding, processo de mudança, ADRs
├── release-please-config.json
└── .release-please-manifest.json
```

## Como rodar localmente

```bash
cd mobile
flutter pub get
flutter run -d chrome          # ou um emulador Android
```

Antes de abrir um Pull Request, rode o mesmo que o CI roda:

```bash
cd mobile
dart format .
flutter analyze
flutter test --coverage
bash ../scripts/check_coverage.sh coverage/lcov.info 70
```

## Publicação do repositório

Passo a passo de criação e configuração no GitHub: [docs/guia-publicacao.md](docs/guia-publicacao.md).

## Como contribuir

Leia [CONTRIBUTING.md](CONTRIBUTING.md) e [docs/onboarding.md](docs/onboarding.md).
Resumo: **Issue (SM) → branch `feature/<issue>-<descricao>` → Pull Request → revisão + CI verde → squash merge → CD**.

## Comunicação

Canal oficial de avisos: **[GitHub Discussions](https://github.com/LaminLeonardo/moneyhub-mobile/discussions)** (categoria *Announcements*).
Janela de resposta a Pull Requests: **até 2 dias úteis**.

## Licença

[MIT](LICENSE) © 2026 Leonardo Lamin
