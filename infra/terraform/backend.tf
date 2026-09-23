# Estado centralizado e versionado no HCP Terraform (plano gratuito),
# nunca em máquinas locais (PGCS 7.1).
terraform {
  cloud {
    organization = "laminleonardo"

    workspaces {
      name = "moneyhub-mobile-github"
    }
  }
}
