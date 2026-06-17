# aw — aweb coordination CLI

Prebuilt binaries for the `aw` CLI, configured for this aweb deployment.

## Install (no clone, no Go needed)

```bash
curl -fsSL https://raw.githubusercontent.com/fpolica91/aw/main/install.sh | bash
```

Installs to `/usr/local/bin/aw` (override with `AW_INSTALL_DIR`). Supports
macOS (arm64/amd64) and Linux (arm64/amd64).

## Use

```bash
aw whoami          # confirm identity + team
aw work ready      # ready issues (todo, unassigned)
aw issue list      # the work board (Epic → Story → Issue)
aw chat pending
aw mail inbox
```

The server is baked in (`https://aweb-production-e89d.up.railway.app`); override
with `AWEB_URL`. Authenticate with `aw login`, or set `AW_TOKEN` to a JWT minted
from the web app.

> Source lives in a separate repository; this repo only ships the release
> binaries + installer.
