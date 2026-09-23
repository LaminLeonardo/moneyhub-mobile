# Configuração do repositório e da plataforma de entrega como código.
# Adoção: `terraform import`/bloco import abaixo traz o repositório existente
# para o estado; a partir daí, qualquer mudança passa por PR + validação.

data "github_user" "owner" {
  username = var.github_owner
}

import {
  to = github_repository.this
  id = "moneyhub-mobile"
}

resource "github_repository" "this" {
  name        = var.repository
  description = "MoneyHub Mobile — cliente Flutter do MoneyHub com CI/CD (PGCS)"
  visibility  = "public"

  has_issues      = true
  has_discussions = true
  has_projects    = true
  has_wiki        = false

  # Squash merge: o título do PR (Conventional Commit) vira o commit na main
  allow_squash_merge     = true
  allow_merge_commit     = false
  allow_rebase_merge     = false
  delete_branch_on_merge = true

  vulnerability_alerts = true

  lifecycle {
    prevent_destroy = true
  }
}

# Proteção da branch main (PGCS 3.3 e 5.2)
resource "github_branch_protection" "main" {
  repository_id = github_repository.this.node_id
  pattern       = "main"

  enforce_admins          = true
  required_linear_history = true
  allows_force_pushes     = false
  allows_deletions        = false

  required_status_checks {
    strict   = true
    contexts = var.required_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = var.required_approvals
    dismiss_stale_reviews           = true
  }
}

# Ambientes de implantação (PGCS 3.2)
resource "github_repository_environment" "homologacao" {
  repository  = github_repository.this.name
  environment = "homologacao"
}

resource "github_repository_environment" "producao" {
  repository  = github_repository.this.name
  environment = "producao"

  # Gate de release: aprovação manual obrigatória
  reviewers {
    users = [data.github_user.owner.id]
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
