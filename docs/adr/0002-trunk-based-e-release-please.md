# ADR 0002 — Trunk-based development, SemVer e release-please

- **Status:** aceito
- **Data:** 22/09/2026

## Contexto
O PGCS exige integração contínua real, versionamento semântico e baselines geradas automaticamente.

## Decisão
- Estratégia **trunk-based** (GitHub Flow): `main` protegida e sempre implantável; branches curtas.
- **Squash merge** com título de PR em **Conventional Commits** (validado no CI).
- **release-please** calcula a próxima versão SemVer, atualiza `pubspec.yaml` e `CHANGELOG.md`
  e cria a tag `vX.Y.Z` + GitHub Release (baseline de produto).

## Consequências
- (+) Changelog e versão gerados sem trabalho manual.
- (+) Cada release rastreia commits, PRs e issues.
- (−) O PR de release precisa de um token pessoal (`RELEASE_PLEASE_TOKEN`) para disparar o CI.
