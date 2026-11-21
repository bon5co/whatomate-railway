# Whatomate wrapper for Railway. The official image reads its settings from WHATOMATE_<SECTION>__<KEY> variables and refuses to start in
# production without a 32-character JWT secret and an allowed-origins list; its default administrator is admin@admin.com / admin. This
# image builds every WHATOMATE_* setting from the Railway variables, binds to Railway's injected PORT, and creates the administrator
# from WHATOMATE_ADMIN_EMAIL / WHATOMATE_ADMIN_PASSWORD, so nobody has to type a setting and nobody can sign in with the stock login.
# upstream: shridarpatil/whatomate
FROM shridh0r/whatomate:0.1.1-beta-0.17@sha256:8091fd13661bc51d5e14e7fbf25a4792e781b85e10b715172bf22aa87ed1e669

COPY --chmod=0755 boot.sh /railway-boot.sh

EXPOSE 8080
ENTRYPOINT ["/railway-boot.sh"]
CMD ["./whatomate", "server", "-config", "config.toml", "-migrate"]
