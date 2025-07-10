## ✨ DevContainer Base Image Setup

This project helps you build a reusable, versioned Go development image with common tools and a customized Zsh experience.

---

## 🛠️ Usage

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
make 1.18
```

> You can define multiple Go versions in the `Makefile` and build them as needed.

---

### 3. Copy `devcontainer.json`

* Update the `"name"` field to match your project
* Customize as needed (e.g., ports, extensions, env variables)

---

### 4. Start Local Dependencies

If your project relies on services like MySQL or Redis, use the shared `docker-compose.yml`:

```bash
docker compose -f util/docker-compose.yml up -d
```

Example:

```yaml
# util/docker-compose.yml
services:
  mysql:
    ports:
      - "4306:3306"  # Expose MySQL container's port 3306 to host port 4306
```

---

### 5. Port Forwarding into DevContainer with socat

To simulate a local development environment inside the DevContainer:

1. **Expose MySQL on the host** via port `4306`
2. In `post-start-cmd.sh`, forward that port into the container:

```bash
nohup socat TCP-LISTEN:3306,fork,reuseaddr TCP:host.docker.internal:4306 > /tmp/socat-mysql.log 2>&1 &
```

3. This allows your app inside the DevContainer to access MySQL at `127.0.0.1:3306`, just like a native local setup.

> Make sure you include `"--add-host=host.docker.internal:host-gateway"` in your `devcontainer.json` under `runArgs`:

```json
"runArgs": [
  "--add-host=host.docker.internal:host-gateway"
]
```

---

Now your DevContainer is set up to behave like a local machine, with minimal changes to your existing environment!
