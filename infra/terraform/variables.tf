variable "github_owner" {
  description = "Usuário/organização dono do repositório"
  type        = string
  default     = "LaminLeonardo"
}

variable "repository" {
  description = "Nome do repositório"
  type        = string
  default     = "moneyhub-mobile"
}

variable "required_approvals" {
  description = "Número mínimo de aprovações em Pull Requests"
  type        = number
  default     = 1
}

variable "required_checks" {
  description = "Status checks do CI obrigatórios para merge na main"
  type        = list(string)
  default     = ["pr-title", "build-test", "security", "docker-build"]
}
