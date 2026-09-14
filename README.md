# Debian Desktop for Railway

A persistent Debian 12 Xfce desktop that runs on [Railway](https://railway.com)
and is available from any modern browser. The image includes Google Chrome,
Thunar, a terminal, Git, and an HTTPS-ready noVNC client.

The public desktop is protected with HTTP Basic Authentication. The container
will refuse to start unless `PASSWORD` is set.

## Deploy on Railway

1. Create a Railway project from this GitHub repository.
2. Add a volume mounted at `/config` so browser profiles, desktop settings, and
   files in the home directory survive redeploys.
3. Set a secret `PASSWORD` variable. Optionally set `USERNAME` (the default is
   `admin`) and `RESOLUTION` (the default is `1440x900`).
4. Generate a public domain for the service. Railway detects the root
   `Dockerfile`, uses the injected `PORT`, and checks `/healthz` automatically.
5. Open the generated domain and sign in with the configured credentials.

Railway terminates HTTPS at its edge. Both the noVNC page and its WebSocket are
served through the same authenticated endpoint.

### Prebuilt image

The GitHub Actions pipeline builds the image on every pull request. Pushes to
the repository's default branch also publish these images:

```text
ghcr.io/nhm7/homeassistant-vm:latest
ghcr.io/nhm7/homeassistant-vm:<commit-sha>
```

Railway can deploy the prebuilt `latest` image instead of building this
repository. Configure the same variables, public port, health-check path, and
`/config` volume described above. GitHub Container Registry packages are
private by default unless their package visibility is changed to public.

The published container is a standard OCI image. Home Assistant Container or
Home Assistant OS does not automatically turn it into a Supervisor add-on; the
old add-on manifests were intentionally removed as part of the Railway-only
conversion.

## Configuration

| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| `PASSWORD` | Yes | — | Password protecting the entire browser desktop. |
| `USERNAME` | No | `admin` | HTTP Basic Authentication username. |
| `RESOLUTION` | No | `1440x900` | Virtual screen size, formatted as `WIDTHxHEIGHT`. |
| `PORT` | Railway | `8080` | HTTP port; Railway supplies this automatically. |

The persistent home directory is `/config/home`. Software installed while the
container is running is ephemeral; bake additional packages into the
`Dockerfile` if they must survive a redeploy.

> [!IMPORTANT]
> This is a containerized desktop, not a hardware virtual machine. It shares the
> host kernel, and Chrome runs with its sandbox disabled because the graphical
> session runs as the container's root user. Do not use it for untrusted sites
> or workloads requiring VM-level isolation.

## Local development

```sh
docker build -t debian-desktop .
docker run --rm -p 8080:8080 \
  -e PASSWORD='replace-with-a-strong-password' \
  -v debian-desktop-data:/config \
  debian-desktop
```

Then visit <http://localhost:8080> and sign in as `admin`.

Run the repository checks with:

```sh
./scripts/check.sh
```

## License

MIT — see [LICENSE](LICENSE).
