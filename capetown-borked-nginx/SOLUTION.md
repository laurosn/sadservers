# Cape Town: Borked Nginx — Troubleshooting & Solution

**Scenario:** "Cape Town" (SadServers) — Level: Medium, Type: Fix
**Tags:** nginx, systemd
**Objective:** `curl -I 127.0.0.1:80` returns "Connection refused". Fix it so curling returns the
default Nginx page.

**Verification test:**
```bash
curl -Is 127.0.0.1:80 | head -1
# Expected: HTTP/1.1 200 OK
```

This scenario had **two stacked faults** — fixing the first revealed the second.

---

## Troubleshooting Steps

### 1. Reproduce + check the service

```bash
curl -Is 127.0.0.1:80 | head -1          # (no output — connection refused)
sudo systemctl status nginx --no-pager
sudo nginx -t
```
```
Active: failed (Result: exit-code)
nginx: [emerg] unexpected ";" in /etc/nginx/sites-enabled/default:1
nginx: configuration file /etc/nginx/nginx.conf test failed
```

nginx won't start because its config fails validation.

### 2. Fault #1 — stray semicolon in the site config

```bash
ls -l /etc/nginx/sites-enabled/default   # symlink -> ../sites-available/default
sudo head -1 /etc/nginx/sites-available/default | cat -n
```
```
1	;
```

The standard Debian default site starts with a `##` comment block. A bogus `;` had been
injected as line 1. Remove it:

```bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sudo sed -i '1{/^;$/d}' /etc/nginx/sites-available/default
sudo nginx -t            # syntax is ok
sudo systemctl restart nginx
curl -Is 127.0.0.1:80 | head -1
```
```
HTTP/1.1 500 Internal Server Error
```

Config is valid and nginx runs now — but it returns **500**, not 200. Second fault.

### 3. Fault #2 — file-descriptor limit too low

```bash
sudo tail -5 /var/log/nginx/error.log
```
```
[alert] socketpair() failed while spawning "worker process" (24: Too many open files)
[crit]  open() "/var/www/html/index.nginx-debian.html" failed (24: Too many open files)
```

The docroot and index file exist and are readable, so the problem is the process FD limit, not
the content. Check nginx + systemd limits:

```bash
grep -nE 'worker_connections|worker_rlimit_nofile' /etc/nginx/nginx.conf   # worker_connections 768 (fine)
grep -niE 'LimitNOFILE' /etc/systemd/system/nginx.service
```
```
14:LimitNOFILE=10
```

**Root cause:** the systemd unit capped nginx at `LimitNOFILE=10` (10 open files total) — far
too low for a worker to open sockets and serve files, producing errno 24 "Too many open files"
and the 500. A standard nginx unit has no such line.

---

## Solution

```bash
# Fault #1: remove the stray ';' on line 1 of the site config
sudo sed -i '1{/^;$/d}' /etc/nginx/sites-available/default

# Fault #2: remove the crippling FD limit from the systemd unit
sudo sed -i '/^LimitNOFILE=10$/d' /etc/systemd/system/nginx.service
sudo systemctl daemon-reload

# Apply
sudo systemctl restart nginx
```

### Verify

```bash
curl -Is 127.0.0.1:80 | head -1
```
```
HTTP/1.1 200 OK
```

✅ Fixed. `systemctl is-active nginx` → `active`.

---

## Notes

- Classic "fix one layer, find another." Always re-run the verification test after each fix;
  a passing `nginx -t` only means the config parses, not that requests succeed.
- `Too many open files (24)` from a service that serves few files almost always points at an
  artificially low `LimitNOFILE` (systemd) or `worker_rlimit_nofile`/`ulimit -n`, not real
  resource exhaustion. Confirm via `cat /proc/<pid>/limits`.
- After editing a unit file under `/etc/systemd/system/`, you must `daemon-reload` before the
  change takes effect.
