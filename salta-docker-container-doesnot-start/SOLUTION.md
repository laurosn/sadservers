# Salta: Docker Container Won't Start — Troubleshooting & Solution

**Scenario:** "Salta" (SadServers) — Level: Medium, Type: Fix
**Tags:** docker, node.js
**OS:** Debian 11 — **Root access: No** (passwordless `sudo` is available, though)
**Objective:** From the dockerized Node.js app in `/home/admin/app`, get a web app running on
port `:8888`. There must be **only one running Docker container**.

**Verification test:**
```bash
curl localhost:8888        # -> Hello World!   (from a running container)
```

Three faults were stacked together.

---

## Troubleshooting Steps

### 1. Inspect the app and Docker state

```bash
ls -la /home/admin/app
cat /home/admin/app/Dockerfile
cat /home/admin/app/server.js
docker ps -a            # -> permission denied on /var/run/docker.sock
```

- `docker` as `admin` fails (`permission denied ... docker.sock`) — the user isn't in the
  `docker` group. But `sudo -n docker ps` works (**passwordless sudo**), so use `sudo docker`.
- `server.js` listens on `process.env.PORT || 8888` → the app's port is **8888**.

### 2. Fault #1 & #2 — bugs in the Dockerfile

```dockerfile
EXPOSE 8880                  # wrong: app uses 8888
CMD [ "node", "serve.js" ]   # wrong: the file is server.js, not serve.js
```

The `CMD` typo means the container starts then immediately crashes (`Cannot find module
'serve.js'`). Fix both:

```bash
cp /home/admin/app/Dockerfile /home/admin/app/Dockerfile.bak
sed -i 's/serve.js/server.js/; s/EXPOSE 8880/EXPOSE 8888/' /home/admin/app/Dockerfile
```

### 3. Build, then hit Fault #3 — port already in use

```bash
cd /home/admin/app
sudo docker build -t saltaapp .                       # builds OK
sudo docker run -d -p 8888:8888 --name saltaapp saltaapp
```
```
docker: Error response from daemon: driver failed programming external connectivity ...
Error starting userland proxy: listen tcp4 0.0.0.0:8888: bind: address already in use.
```

Find who owns the port:

```bash
sudo ss -ltnp | grep 8888
# LISTEN 0 511 0.0.0.0:8888 ... users:(("nginx",pid=630,...))
```

**A host `nginx` process is bound to 8888**, blocking the container from publishing the port.
The test must be served by the *container*, so nginx has to release 8888.

---

## Solution

```bash
# Fault #1/#2: fix the Dockerfile (CMD filename + EXPOSE port)
sed -i 's/serve.js/server.js/; s/EXPOSE 8880/EXPOSE 8888/' /home/admin/app/Dockerfile

# Fault #3: free port 8888 by stopping the host nginx
sudo systemctl stop nginx
sudo systemctl disable nginx        # so it doesn't grab the port again on reboot

# Clean up the half-created container from the failed run
sudo docker rm saltaapp

# Build and run
cd /home/admin/app
sudo docker build -t saltaapp .
sudo docker run -d -p 8888:8888 --name saltaapp saltaapp
```

### Verify

```bash
curl -s localhost:8888           # -> Hello World!
sudo docker ps -q | wc -l        # -> 1   (only one running container)
```
```
Hello World!
1
```

✅ Fixed.

---

## Notes

- `sudo docker` is the workaround for the socket permission error (no need to add `admin` to the
  `docker` group, which would also require a re-login to take effect).
- The pre-existing exited container (`elated_taussig`, image `app`) is harmless — "only one
  running container" counts running, not exited — but the failed `saltaapp` had to be `docker rm`'d
  before reusing the name.
- Order of debugging mattered: the `CMD` typo would crash the container even if the port were
  free, and the port conflict would block `run` even with a correct image. Both had to be fixed.
