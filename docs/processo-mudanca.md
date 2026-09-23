# Processo de Gerência de Mudanças

Resumo operacional das seções 8 e 9 do PGCS.

## Fluxo padrão (mudanças de rotina)

```
Issue (SM)  ->  branch feature/<n>-...  ->  commits (Conventional Commits)
     ->  Pull Request  ->  CI (pr-title, build-test, security, docker-build)
     ->  revisão (1 aprovação)  ->  squash merge na main
     ->  CD: build único -> Homologação -> smoke test
     ->  release-please (PR de release) -> tag vX.Y.Z (baseline)
     ->  gate de aprovação -> Produção -> smoke test
```

## Ciclo de vida da Solicitação de Mudança (labels)

| Label | Quando |
|---|---|
| `status:nova` | Issue criada (automático pelo template) |
| `status:atribuida` | Analisada, priorizada e com responsável |
| `status:em-andamento` | Branch criada |
| `status:finalizada` | PR integrado na `main` (a issue é fechada pelo `Closes #n`) |
| `status:verificada` | Validada em Homologação |
| `status:fechada` | Entregue em Produção (consta no CHANGELOG da release) |
| `status:rejeitada` | Não será implementada (justificativa registrada na issue) |

## Quando acionar o CCM

Marque a SM com `ccm:necessario` quando a mudança:

1. altera a proteção da `main`, os environments ou qualquer arquivo em `infra/`;
2. altera os pipelines de CD/rollback (`cd.yml`, `rollback.yml`);
3. é um *hotfix* aplicado fora do fluxo padrão;
4. é uma *breaking change* (`feat!`) ou muda o contrato com a API do MoneyHub;
5. aumenta o escopo acordado da iteração.

O CCM registra a decisão como comentário na issue e aplica `ccm:aprovada` ou `ccm:rejeitada`.

## Correção emergencial (hotfix)

1. Abrir issue de defeito com severidade **Crítica** e label `hotfix`.
2. Se a produção estiver quebrada: executar o workflow **Rollback** com a última tag estável.
3. Criar `hotfix/<n>-...` a partir da `main`, PR com título `fix: ...`, revisão e CI verde (o fluxo não é pulado).
4. Após a release, registrar no PR/issue a decisão do CCM (manter a correção ou refatorar + novos testes).
