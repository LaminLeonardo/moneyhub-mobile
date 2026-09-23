# ADR 0001 — Flutter como tecnologia do cliente MoneyHub Mobile

- **Status:** aceito
- **Data:** 22/09/2026

## Contexto
O MoneyHub já possui backend .NET e frontend web em React. É necessário um cliente mobile,
desenvolvido individualmente, que também possa ser demonstrado no navegador.

## Decisão
Usar **Flutter/Dart**: um único código gera APK Android e build Web. A versão web permite
publicar Homologação e Produção gratuitamente no GitHub Pages e empacotar uma imagem Docker (nginx).

## Consequências
- (+) Um pipeline gera dois artefatos (APK e Web) a partir do mesmo commit.
- (+) `flutter analyze` e `flutter test` integram facilmente ao CI.
- (−) Dart não é suportado pelo CodeQL: a análise estática fica a cargo do analisador do Dart + gitleaks.
