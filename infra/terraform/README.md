# Infraestrutura como Código (Terraform)

Descreve, como código versionado, a configuração da plataforma de entrega do
projeto no GitHub:

| Recurso | O que controla |
|---|---|
| `github_repository.this` | Configurações do repositório (squash merge, discussions, alertas de vulnerabilidade) |
| `github_branch_protection.main` | Proteção da `main`: PR obrigatório, 1 aprovação, checks do CI, sem bypass de admin |
| `github_repository_environment.homologacao` | Ambiente de Homologação (deploy automático) |
| `github_repository_environment.producao` | Ambiente de Produção com aprovação manual (gate de release) |

Estado remoto: HCP Terraform (organização `laminleonardo`, workspace `moneyhub-mobile-github`).

## Fluxo

1. Alteração em `infra/**` → Pull Request → workflow **IaC** executa `terraform fmt` e `terraform validate`.
2. Após aprovação e merge, o responsável de GCS executa o `plan`/`apply`:

```bash
cd infra/terraform
export GITHUB_TOKEN=<token com escopo repo/admin>   # nunca versionar
terraform login          # uma vez, para o HCP Terraform
terraform init
terraform plan
terraform apply
```
