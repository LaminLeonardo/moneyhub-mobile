output "repository_url" {
  value = github_repository.this.html_url
}

output "environments" {
  value = [
    github_repository_environment.homologacao.environment,
    github_repository_environment.producao.environment,
  ]
}
