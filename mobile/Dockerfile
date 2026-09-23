# Imagem imutável do MoneyHub Web.
# O build do Flutter é feito UMA vez pelo pipeline (CI/CD); esta imagem apenas
# empacota o artefato já compilado (build/web), garantindo que a mesma versão
# seja promovida entre ambientes sem recompilação.
FROM nginx:1.31-alpine

LABEL org.opencontainers.image.source="https://github.com/LaminLeonardo/moneyhub-mobile" \
      org.opencontainers.image.description="MoneyHub Mobile - build web" \
      org.opencontainers.image.licenses="MIT"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY build/web /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost/ >/dev/null || exit 1
