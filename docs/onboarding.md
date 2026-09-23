# Onboarding — MoneyHub Mobile

Bem-vindo(a)! Este guia resume o que é preciso para colaborar.

## Canal de comunicação

- **Canal único de avisos:** [GitHub Discussions → Announcements](https://github.com/LaminLeonardo/moneyhub-mobile/discussions/categories/announcements)
- Dúvidas técnicas: GitHub Discussions → Q&A
- Mudanças e defeitos: **sempre** via Issue (templates SM / Defeito), nunca só por mensagem.

## Acordo de trabalho assíncrono

| Item | Acordo |
|---|---|
| Janela de resposta a Pull Requests | **até 2 dias úteis** |
| Duração máxima de uma branch de feature | 2 dias |
| Tamanho recomendado de PR | até ~300 linhas alteradas |
| Commit direto na `main` | **proibido** (proteção de branch, sem bypass) |
| Merge | somente *squash merge*, com 1 aprovação + CI verde |

## Ambiente de desenvolvimento

- Flutter SDK (canal *stable*) e Dart 3.4+
- VS Code com extensões Flutter e Dart (ou Android Studio)
- Git + terminal Git Bash (Windows)
- Emulador Android (Android Studio) ou Chrome para a versão web

## Primeiros passos

```bash
git clone https://github.com/LaminLeonardo/moneyhub-mobile.git
cd moneyhub-mobile/mobile
flutter pub get
flutter test
flutter run -d chrome
```

Depois leia o [CONTRIBUTING.md](../CONTRIBUTING.md) e o [processo de mudança](processo-mudanca.md).
