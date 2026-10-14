# Railway self-hosting (fork-specific)

This fork runs the upstream Docker image build on Railway. Nothing in upstream
code is changed; this folder only adds a password-protected proxy.

## Services

| Service | Source | Purpose |
| --- | --- | --- |
| `openseo` | repo root, `deploy/docker/Dockerfile` | The app (Workers runtime, D1/SQLite, KV, R2, workflows, built-in 5-minute scheduler). Private only, no public domain. |
| `openseo-auth-proxy` | `deploy/railway/auth-proxy` | Caddy with HTTP basic auth. The only public entry point. |

The app runs with `AUTH_MODE=local_noauth` (no login of its own), so it must
stay behind the proxy.

## Storage

A Railway volume on `openseo` is mounted at `/app/.wrangler`. It holds the
SQLite database and all other app state. Don't detach or wipe it.

## Variables

`openseo`:

- `RAILWAY_DOCKERFILE_PATH=deploy/docker/Dockerfile`
- `CLOUDFLARE_INCLUDE_PROCESS_ENV=true`
- `AUTH_MODE=local_noauth`
- `PORT=3001`
- `ALLOWED_HOST=<the proxy's public domain>`
- `VITE_SHOW_DEVTOOLS=false`
- `DATAFORSEO_API_KEY` (secret, base64 of `login:password`)
- Optional: `OPENROUTER_API_KEY`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`,
  `BETTER_AUTH_SECRET`, `CONTEXT_API_KEY`

`openseo-auth-proxy`:

- `PORT=8080`
- `UPSTREAM=${{openseo.RAILWAY_PRIVATE_DOMAIN}}:${{openseo.PORT}}`
- `BASIC_AUTH_USER`
- `BASIC_AUTH_PASSWORD` (secret; hashed with bcrypt at startup)

## Pulling upstream updates

On GitHub, open this fork and click **Sync fork → Update branch**. Railway
redeploys `openseo` automatically from `main`. The app rebuilds itself on
container start (a few minutes), runs pending migrations against the volume,
then serves.
