## ✨ DevContainer Base Image Setup

This project helps you build a reusable, versioned Go development image with common tools and a customized Zsh experience.

## 📖 Table of Contents

- [Quick Start](#-quick-start)
- [Detailed Usage](#️-detailed-usage)
- [Technical Details](#-technical-details)

---

## 🚀 Quick Start

1. **Build the image**: `make 1.23` (or your preferred Go version)
2. **Copy and customize** `devcontainer.json` for your project
3. **Start dependencies** (if needed): `docker compose -f utils/docker-compose.yml up -d`
4. **Open in VS Code** and enjoy your fully configured Go environment!

---

## 🛠️ Detailed Usage

### 1. Prepare Local Zsh Config (Optional but Recommended)

If you want to use your own `zsh` and `Powerlevel10k` settings, copy them into the `zsh-config/` directory:

```bash
mkdir -p zsh-config/plugins
cp ~/.zshrc zsh-config/
cp ~/.p10k.zsh zsh-config/
```

> The repo provides example versions of `.zshrc` and `.p10k.zsh`, but feel free to replace them with your own.

You can also edit the files directly inside `zsh-config/`.

No need to manually copy plugins — the following plugins are automatically cloned during image build:

* `zsh-autosuggestions`
* `zsh-syntax-highlighting`
* `powerlevel10k`

---

### 2. Build the Image

Use `make` to build the desired Go version image:

```bash
# Build specific versions
make 1.18  # Go 1.18 with gopls v0.9.5, mockery v2.20.0
make 1.21  # Go 1.21 with gopls v0.12.1, mockery v2.32.4  
make 1.23  # Go 1.23 with gopls v0.17.0, mockery v2.47.0

# Build all versions at once
make all
```

> Each version includes version-specific tooling optimized for that Go release.

---

### 3. Copy `devcontainer.json`

* Update the `"name"` and `"workspaceFolder"` fields to match your project
* Update the `"image"` field to match your built version (e.g., `"devcontainer-go:1.23"`)
* Customize ports, VS Code extensions, and environment variables as needed

**Example customization:**
```json
{
  "name": "my-go-project",
  "image": "devcontainer-go:1.23",
  "workspaceFolder": "/my-go-project",
  "mounts": [
    "source=${localWorkspaceFolder},target=/my-go-project,type=bind,consistency=cached"
  ]
}
```

---

### 4. Start Local Dependencies

If your project relies on services like MySQL or Redis, use the shared `docker-compose.yml`:

```bash
docker compose -f utils/docker-compose.yml up -d
```

Example:

```yaml
# utils/docker-compose.yml
services:
  mysql:
    ports:
      - "4306:3306"  # Expose MySQL container's port 3306 to host port 4306
```

---

---

## 🔧 Technical Details

### Port Forwarding with socat

This setup uses `socat` to seamlessly forward container ports to host services, allowing your application to use standard connection strings (like `127.0.0.1:3306` for MySQL) while avoiding port conflicts.

**How it works:**
1. Host services run on non-standard ports (MySQL: 4306, Redis: 7379, MongoDB: 37017)
2. The `post-start-cmd.sh` script forwards standard ports in the container to host ports:

```bash
# Forward MySQL (3306 in container → 4306 on host)
nohup socat TCP-LISTEN:3306,fork,reuseaddr TCP:host.docker.internal:4306 > /tmp/socat-mysql.log 2>&1 &

# Forward Redis (6379 in container → 7379 on host)  
nohup socat TCP-LISTEN:6379,fork,reuseaddr TCP:host.docker.internal:7379 > /tmp/socat-redis.log 2>&1 &

# Forward MongoDB (27017 in container → 37017 on host)
nohup socat TCP-LISTEN:27017,fork,reuseaddr TCP:host.docker.internal:37017 > /tmp/socat-mongo.log 2>&1 &
```

3. Your application connects to standard ports as if running locally

> **Required:** Include `"--add-host=host.docker.internal:host-gateway"` in your `devcontainer.json` under `runArgs` for this to work.

---

**🎉 Result:** Your DevContainer behaves exactly like a local development environment!
