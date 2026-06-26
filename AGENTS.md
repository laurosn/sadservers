# AGENTS.md — SadServers Troubleshooting Playbook

This repo holds [SadServers](https://sadservers.com)-style troubleshooting scenarios. Each
scenario lives in its own directory containing a `README.md`. When the user points you at a
new scenario directory and asks you to troubleshoot it, follow this playbook.

## What a scenario looks like

Each scenario directory has a `README.md` with:
- **Scenario / Level / Type** (`Fix`, `Find`, etc.) and **Tags** hinting at the problem area.
- **Description** — the objective.
- **Test** — the exact command that must succeed, and its **expected output**.
- **Private key** (RSA block) + **Direct SSH access** line with the target IP and user
  (usually `admin@<ip>`).

The fix happens on the **remote box over SSH**, not in this repo. The repo is just where you
record notes and the solution.

## Workflow

1. **Read the `README.md`** in the target directory. Extract: the objective, the exact
   verification **Test** command + expected output, and the SSH details (IP, user, private key).

2. **Set up the SSH key** (idempotent — the file may already exist from a prior scenario):
   ```bash
   chmod 600 ~/.ssh/sadkey 2>/dev/null   # prior scenario left it mode 400 → overwrite fails silently
   # paste the new key block from the README into ~/.ssh/sadkey
   chmod 400 ~/.ssh/sadkey
   ssh -i ~/.ssh/sadkey -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o ConnectTimeout=15 admin@<ip> 'whoami; hostname'
   ```
   - The IP changes per scenario/session — always take it from the current README, never reuse an
     old one.
   - **`chmod 600` first:** the previous scenario leaves the key at mode 400 (read-only), so a
     `cat > ~/.ssh/sadkey` heredoc gets "permission denied" and silently keeps the OLD key.
   - **Use `-o IdentitiesOnly=yes`:** otherwise ssh may offer other agent keys first and hit
     "Too many authentication failures" before trying this one.

3. **Reproduce the problem first.** Run the README's Test command verbatim and capture the real
   error before changing anything. Don't assume the cause from the tags.

4. **Diagnose from the symptom outward.** Read the actual error and logs rather than guessing.
   Common entry points by tag:
   - **systemd / service**: `systemctl status <unit>`, `journalctl -u <unit> --no-pager -n 50`
   - **disk volumes**: `df -h`, `df -i` (inodes!), `mount`, `du -xh -d1 <dir> | sort -h`,
     `find <dir> -xdev -type f -size +10M -exec ls -lh {} \;`
   - **permissions**: `ls -l`, ownership/mode of data dirs, `getfacl`, SELinux/AppArmor
   - **networking / ports**: `ss -ltnp`, `curl -v`, firewall rules (`iptables -L`, `ufw status`)
   - **config**: locate the config file named in the README, diff against expectation
   - **process / resources**: `ps aux`, `top`, `free -h`, `ulimit -a`
   - Always read the service's own log file (path often shown in `systemctl status`).

5. **Form a hypothesis, state the root cause, then apply the minimal fix.** Prefer the smallest
   change that resolves the issue.

6. **Verify** by re-running the README's exact Test command and confirming it matches the
   expected output. Don't declare success until it does.

## Safety rules

- **These boxes are authorized practice servers** — full `sudo` is expected and intended.
- **Look before you destroy.** Before `rm`/overwrite/truncate, inspect the target (`ls -l`,
  `file`, `du`, peek at contents). If something you're about to delete looks like real data you
  didn't create, prefer **moving/relocating** it over deleting, and call out the tradeoff.
- Make **reversible, minimal** changes. Don't reconfigure unrelated services or "tidy up."
- Capture command output as evidence; report failures honestly, including the raw error.

## Deliverables

Unless the user says otherwise:
- Fix the issue on the remote box and verify with the Test command.
- Give a short summary: **root cause → fix → verification output**.
- When asked to document, write a `SOLUTION.md` **inside that scenario's directory** following
  the structure used in `manhattan-cant-write-database/SOLUTION.md`: Troubleshooting Steps
  (with real commands + outputs), Solution, Verify, and a short Notes/lessons section.

## Reference

- Example worked scenario: [`manhattan-cant-write-database/`](manhattan-cant-write-database/)
  — Postgres failing to start because a dedicated data volume was filled to 100% by stray
  backup files; fix was freeing space and restarting the service.
