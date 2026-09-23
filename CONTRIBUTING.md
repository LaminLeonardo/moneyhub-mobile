# Como contribuir

Este projeto segue o **PGCS** (docs/pgcs). Toda mudança é rastreável de ponta a ponta:
**Issue → branch → commits → Pull Request → pipeline → release**.

## 1. Registre a mudança

Abra uma issue com o template **Solicitação de Mudança (SM)** ou **Relato de Defeito**.
O número da issue é o identificador da mudança.

## 2. Crie a branch a partir da `main` atualizada

| Tipo | Convenção | Exemplo |
|---|---|---|
| Funcionalidade/melhoria | `feature/<issue>-<descricao-curta>` | `feature/42-cadastro-categoria` |
| Correção | `fix/<issue>-<descricao-curta>` | `fix/57-saldo-negativo` |
| Correção emergencial | `hotfix/<issue>-<descricao-curta>` | `hotfix/60-tela-branca` |
| Documentação/infra | `docs/<issue>-...`, `ci/<issue>-...` | `ci/15-cache-flutter` |

Branches devem durar no máximo **2 dias** (trunk-based development).

```bash
git switch main && git pull
git switch -c feature/42-cadastro-categoria
```

## 3. Faça commits no padrão Conventional Commits

```
<tipo>(<escopo>): <descrição no imperativo>
```

Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
Mudança incompatível: `feat!:` ou rodapé `BREAKING CHANGE:`.

Exemplos: `feat(lancamentos): adiciona filtro por categoria`, `fix(saldo): corrige arredondamento de centavos`.

## 4. Abra o Pull Request

- Título no padrão Conventional Commits (validado pelo CI — vira o commit na `main` via *squash merge*).
- Descrição com `Closes #<issue>`.
- Preencha o checklist do template.
- Aguarde **1 aprovação** e **todos os checks verdes** (`pr-title`, `build-test`, `security`, `docker-build`).

## 5. Depois do merge

O pipeline de CD publica automaticamente em **Homologação**. O release-please mantém um PR
`chore: release x.y.z`; quando ele é aprovado e integrado, a release é criada (tag + changelog) e o deploy em
**Produção** aguarda aprovação manual no environment `producao`.
