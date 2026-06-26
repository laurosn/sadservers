# Manhattan: Can't Write Data Into Database — Troubleshooting & Solution

**Scenario:** "Manhattan" (SadServers) — Level: Medium, Type: Fix
**Tags:** disk volumes, postgres, systemd
**Objective:** Be able to insert a row into an existing Postgres database (`dt`).

**Verification test:**
```bash
sudo -u postgres psql -c "insert into persons(name) values ('jane smith');" -d dt
# Expected: INSERT 0 1
```

---

## Troubleshooting Steps

### 1. Reproduce the failure

```bash
sudo -u postgres psql -c "insert into persons(name) values ('jane smith');" -d dt
```
```
psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed:
No such file or directory
	Is the server running locally and accepting connections on that socket?
```

The socket is missing → the Postgres server isn't running.

### 2. Check the service status

```bash
sudo systemctl status postgresql@14-main --no-pager
```
```
Active: failed (Result: protocol)
...
FATAL:  could not create lock file "postmaster.pid": No space left on device
pg_ctl: could not start server
```

Key error: **`No space left on device`**. Postgres can't even create its PID/lock file, so it never starts.

### 3. Inspect disk usage

The config file `/etc/postgresql/14/main/postgresql.conf` defines `data_directory = /opt/pgdata/main`.

```bash
df -h
```
```
Filesystem       Size  Used Avail Use% Mounted on
/dev/nvme1n1p1   7.7G  1.3G  6.0G  18% /
/dev/nvme0n1     8.0G  8.0G   28K 100% /opt/pgdata   <-- FULL
```

`df -i` confirmed it was a space (not inode) problem. The dedicated 8 GB XFS volume mounted at `/opt/pgdata` was **100% full**.

### 4. Find what's consuming the space

The actual database is tiny:

```bash
sudo du -xh -d1 /opt/pgdata | sort -h
```
```
50M	/opt/pgdata/main      <-- actual Postgres data
8.0G	/opt/pgdata
```

So ~8 GB is used by something *other* than the database. Locate large files:

```bash
sudo find /opt/pgdata -xdev -type f -size +10M -exec ls -lh {} \;
```
```
-rw------- 1 postgres postgres 16M  .../main/pg_wal/000000010000000000000001
-rw-r--r-- 1 root     root     7.0G /opt/pgdata/file1.bk   <-- junk
-rw-r--r-- 1 root     root     923M /opt/pgdata/file2.bk   <-- junk
```

**Root cause:** Two stray root-owned backup files (`file1.bk` 7.0 GB, `file2.bk` 923 MB) were dumped directly onto the Postgres data volume, filling it to 100%. With no free space, Postgres couldn't create `postmaster.pid` and failed to start.

---

## Solution

```bash
# 1. Remove the stray files filling the data volume
sudo rm -f /opt/pgdata/file1.bk /opt/pgdata/file2.bk

# 2. Confirm space is freed
df -h /opt/pgdata
#   /dev/nvme0n1    8.0G   92M  8.0G   2% /opt/pgdata

# 3. Restart Postgres
sudo systemctl restart postgresql@14-main
sudo systemctl is-active postgresql@14-main   # -> active
```

### Verify

```bash
sudo -u postgres psql -c "insert into persons(name) values ('jane smith');" -d dt
```
```
INSERT 0 1
```

✅ Fixed.

---

## Notes

- The files were deleted because they were clearly out-of-place junk on the database volume. If such `.bk` files were genuinely needed backups, the correct action would be to **move them off the data volume** (e.g. to `/` or external storage) rather than delete them.
- General lesson: a database's data directory should live on a volume that isn't shared with unrelated large files. When a DB "won't start," always check `systemctl status`/logs for the real error, then `df -h` / `df -i` on the data volume.
