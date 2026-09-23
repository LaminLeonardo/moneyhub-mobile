# Guia de publicação do repositório — passo a passo

Guia para criar o repositório `moneyhub-mobile` no GitHub e deixá-lo pronto para a verificação em laboratório.
Comandos para **Git Bash no Windows** (VS Code). Tempo estimado: 1h a 1h30.

---

## Passo 0 — Pré-requisitos

- Conta GitHub `LaminLeonardo`, Git e Flutter instalados (`flutter doctor` sem erros em Android/Chrome).
- Um **colega da turma** que aceite ser revisor(a) dos seus PRs (a proteção da `main` exige 1 aprovação e o GitHub não deixa você aprovar o próprio PR).

## Passo 1 — Extrair o projeto e gerar as pastas de plataforma

Extraia o `moneyhub-mobile.zip` (por exemplo em `C:\dev\moneyhub-mobile`) e rode:

```bash
cd /c/dev/moneyhub-mobile/mobile

# gera android/ e web/ SEM sobrescrever lib/, test/, pubspec.yaml
flutter create --project-name moneyhub_mobile --org br.com.laminleonardo --platforms android,web .

flutter pub get
dart format .                    # deixa o código no padrão exigido pelo CI
flutter analyze
flutter test --coverage
bash ../scripts/check_coverage.sh coverage/lcov.info 70
flutter run -d chrome            # confira o app rodando
```

> Tudo precisa passar aqui antes do push: é exatamente o que o job `build-test` do CI executa.
> Se o `flutter create` tiver criado um `test/widget_test.dart` de contador, apague-o (o nosso já existe e deve ser mantido).

## Passo 2 — Criar o repositório no GitHub (Exercício 1)

1. GitHub → **New repository** → nome `moneyhub-mobile` → **Public**.
2. **Não** marque README, .gitignore nem licença (eles já estão no projeto).
3. No Git Bash, na raiz do projeto:

```bash
cd /c/dev/moneyhub-mobile
git init -b main
git add .
git commit -m "chore: estrutura inicial do repositório e PGCS"
git remote add origin https://github.com/LaminLeonardo/moneyhub-mobile.git
git push -u origin main
```

Este é o **único** commit direto na `main` (antes da proteção de branch).
O push dispara o workflow **CD**, que deve falhar nesta primeira vez (GitHub Pages ainda não ativado) — é esperado.

## Passo 3 — Baseline inicial v0.1.0

```bash
git tag -a v0.1.0 -m "Baseline inicial: estrutura, app, pipelines e PGCS"
git push origin v0.1.0
```

Depois: GitHub → **Releases → Draft a new release** → tag `v0.1.0` → título `v0.1.0 — Baseline inicial` → **Publish release**.
(O release-please usa essa release como ponto de partida para calcular a próxima versão.)

## Passo 4 — Configurações do repositório

**Settings → General**
- Pull Requests: deixe marcado **somente** *Allow squash merging* → *Default commit message*: **Pull request title**.
- Marque **Automatically delete head branches**.
- Features: marque **Discussions** (canal de comunicação — Exercício 3).

**Settings → Actions → General → Workflow permissions**
- **Read and write permissions** + marque **Allow GitHub Actions to create and approve pull requests**.

**Settings → Environments**
- `homologacao`: criar sem regras.
- `producao`: **Required reviewers** → `LaminLeonardo`; *Deployment branches* → **Selected branches** → `main`.

**Settings → Collaborators** → adicione o colega revisor (permissão *Write*).

**Token do release-please** (para o PR de release disparar o CI):
1. Seu perfil → Settings → Developer settings → **Fine-grained tokens** → *Generate new token*.
2. Repository access: só `moneyhub-mobile`. Permissões: **Contents**, **Pull requests** e **Issues** = *Read and write*.
3. No repositório: Settings → Secrets and variables → Actions → **New repository secret** → nome `RELEASE_PLEASE_TOKEN`.

**Labels:** Actions → workflow **Labels** → *Run workflow* (cria as labels de status/tipo/prioridade/CCM).

**Discussions (Exercício 3):** crie um post em *Announcements*: “Canal oficial de avisos do MoneyHub Mobile. Janela de resposta a PRs: até 2 dias úteis.” O README e o `docs/onboarding.md` já apontam para esse canal.

## Passo 5 — Primeira mudança pelo fluxo completo (Exercício 4)

1. **Issue:** Issues → New issue → **Solicitação de Mudança (SM)** → título `[SM] Exibir quantidade de lançamentos na tela inicial`
   (classificação *Nova funcionalidade*, prioridade *Média*). Suponha que ela receba o número **#1**.

2. **Branch:**

```bash
git switch main && git pull
git switch -c feature/1-contador-lancamentos
```

3. **Alteração** — em `mobile/lib/screens/home_screen.dart`, logo depois do `Text` de “Despesas”, adicione:

```dart
                  Text(
                    '${transactions.length} lançamento(s)',
                    key: const Key('transaction_count'),
                  ),
```

   E em `mobile/test/widget_test.dart`, no teste “tela inicial com dados de exemplo lista lançamentos”, adicione:

```dart
    expect(find.text('3 lançamento(s)'), findsOneWidget);
```

4. **Validar e publicar a branch:**

```bash
cd mobile && dart format . && flutter analyze && flutter test && cd ..
git add .
git commit -m "feat(home): exibe quantidade de lançamentos"
git push -u origin feature/1-contador-lancamentos
```

5. **Pull Request:** título `feat(home): exibe quantidade de lançamentos`, descrição com `Closes #1`, preencha o checklist.
   Aguarde os checks `pr-title`, `build-test`, `security` e `docker-build` ficarem verdes.

## Passo 6 — Proteção da branch main (Exercício 2)

Faça **depois** que o PR do passo 5 rodar o CI uma vez (os nomes dos checks só aparecem para seleção depois disso).

Settings → **Branches** → *Add classic branch protection rule* → Branch name pattern: `main`
- ✅ Require a pull request before merging → Required approvals: **1** → ✅ Dismiss stale approvals
- ✅ Require status checks to pass before merging → ✅ Require branches to be up to date → adicione `pr-title`, `build-test`, `security`, `docker-build`
- ✅ Require linear history
- ✅ **Do not allow bypassing the above settings** (nem administradores contornam as regras)
- Salve.

Agora peça ao colega para **aprovar** o PR e faça **Squash and merge**.

## Passo 7 — Acompanhar o CD

1. Actions → **CD**: o job `build` gera web + APK + imagem; `deploy-homologacao` cria a branch `gh-pages`.
2. **Só na primeira vez:** Settings → **Pages** → Source: *Deploy from a branch* → `gh-pages` / `(root)` → Save.
   Se o job `smoke-homologacao` falhar por isso, espere 1–2 min e clique em **Re-run failed jobs**.
3. Homologação no ar: https://laminleonardo.github.io/moneyhub-mobile/staging/
4. O release-please abre o PR **`chore: release 0.2.0`** (com CHANGELOG). Revisão do colega → Squash and merge.
5. O CD roda de novo, cria a tag `v0.2.0` + Release e o job `deploy-producao` fica **aguardando aprovação** → *Review deployments* → `producao` → **Approve**.
6. Produção no ar: https://laminleonardo.github.io/moneyhub-mobile/ — a Release `v0.2.0` terá o APK e o `.zip` anexados, e a imagem ficará em *Packages*.

## Passo 8 — Publicar o PGCS no Teams

O PDF já está em `docs/pgcs/PGCS_MoneyHub_Mobile.pdf`. Publique **esse PDF** na tarefa do Teams o quanto antes (a ordem de verificação segue a ordem de publicação).

## Checklist para a verificação em laboratório

- [ ] PGCS (PDF) publicado no Teams
- [ ] Repositório público com a estrutura do PGCS (seção 4.3)
- [ ] `main` protegida (tentar `git push` direto na main é rejeitado)
- [ ] Issue SM → branch `feature/1-...` → PR com CI verde e aprovação → squash merge
- [ ] Execuções verdes de CI e CD na aba Actions
- [ ] Homologação e Produção no ar (GitHub Pages) mostrando a versão no rodapé do app
- [ ] Releases `v0.1.0` e `v0.2.0` (CHANGELOG, APK e zip anexados)
- [ ] Imagem em `ghcr.io/laminleonardo/moneyhub-mobile`
- [ ] Discussions com o post de avisos; labels criadas
- [ ] (Opcional — marco M7) Terraform aplicado com estado no HCP Terraform (`infra/terraform/README.md`)

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `build-test` falha em “Formatação” | Rode `dart format .` dentro de `mobile/` e faça novo commit |
| PR de release sem checks (fica bloqueado) | Faltou o secret `RELEASE_PLEASE_TOKEN` (passo 4) |
| `release-please` falha com “not permitted to create pull requests” | Marque *Allow GitHub Actions to create and approve pull requests* (passo 4) |
| `smoke-homologacao` falha na 1ª vez | GitHub Pages ainda não estava ativado (passo 7.2) → Re-run failed jobs |
| Não consigo aprovar meu PR | Correto: o GitHub não permite. O colega colaborador aprova |
| Job `build` do CD falha ao publicar a imagem no GHCR | Settings → Actions → General → *Read and write permissions*; confira se o nome da imagem está em minúsculas |
| Primeira execução do CD (push inicial) falhou | Esperado: Pages e environments ainda não estavam configurados. Ela é substituída pela execução do passo 7 |
