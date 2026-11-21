# whatomate-railway

Wrapper image for [Whatomate](https://github.com/shridarpatil/whatomate) (open source WhatsApp Business platform: shared inbox, chatbot flows, campaigns, templates, REST API; AGPL-3.0) on Railway.

It runs the official `shridh0r/whatomate` image, pinned by digest. Whatomate reads its settings from `WHATOMATE_<SECTION>__<KEY>` variables, refuses to start in production without a 32-character JWT secret and an allowed-origins list, and ships a default administrator of `admin@admin.com` / `admin`. This wrapper builds every `WHATOMATE_*` setting from plain Railway variables, binds to the injected `PORT`, and creates the administrator from `WHATOMATE_ADMIN_EMAIL` and `WHATOMATE_ADMIN_PASSWORD`.

Needs Postgres 17 and Redis alongside it and a volume at `/app/uploads`; the Railway template wires all three. Licence of this wrapper: MIT. Whatomate itself is AGPL-3.0.
