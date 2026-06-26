# Venice: Am I in a Container? — Investigation & Answer

**Scenario:** "Venice" (SadServers) — Level: Medium
**OS:** Debian 11 — **Root access: No** (passwordless `sudo` available)
**Objective:** Figure out whether this machine is a **container** (e.g. Docker) or a **Virtual
Machine** (KVM, etc.). This scenario has no automated test.

## Answer

**It is a Virtual Machine — specifically an AWS EC2 `t3a.nano` instance running on KVM.**
It is *not* a container.

---

## How to tell — the investigation

### 1. Ask systemd directly (quickest answer)

```bash
systemd-detect-virt                  # kvm
sudo systemd-detect-virt --container # none   <-- not a container
sudo systemd-detect-virt --vm        # kvm    <-- it's a VM
```

`systemd-detect-virt` distinguishes VM technologies from container technologies. `kvm` + a
`--container` result of `none` is the headline answer.

### 2. Confirm a hypervisor is present

```bash
grep -o hypervisor /proc/cpuinfo | head -1     # hypervisor   (CPU flag set under a hypervisor)
sudo dmesg | grep -iE 'kvm|hypervisor'
# [    0.000000] Hypervisor detected: KVM
# [    0.000000] kvm-clock: Using msrs ...
```

The kernel ring buffer (`dmesg`) shows this kernel **booting itself** and detecting KVM. A
container never boots a kernel — it shares the host's — so it has no such boot log.

### 3. PID 1 is a real init, not an app entrypoint

```bash
cat /proc/1/comm                 # systemd
tr '\0' ' ' < /proc/1/cmdline    # /lib/systemd/systemd --system --deserialize 60
cat /proc/1/cgroup               # 0::/init.scope
```

In a container, PID 1 is usually the app's entrypoint and `/proc/1/cgroup` shows a
`/docker/<id>` or `/lxc/...` path. Here PID 1 is a full system `systemd` in `/init.scope` — a
normal boot.

### 4. Container-specific markers are absent

```bash
ls -la /.dockerenv                                  # No such file  (Docker drops this file)
cat /proc/1/environ | tr '\0' '\n' | grep container # (empty)       (LXC/nspawn set container=)
```

### 5. It owns hardware: a kernel, a disk, and DMI identity

```bash
uname -a          # ...5.10.0-14-cloud-amd64...  (its own kernel)
lsblk             # nvme0n1 8G -> p1 (/), p14, p15 (/boot/efi)  (a real partitioned disk it boots)
sudo cat /sys/class/dmi/id/sys_vendor /sys/class/dmi/id/product_name
                  # Amazon EC2 / t3a.nano       (VM hardware identity via DMI/SMBIOS)
```

A container has no DMI/SMBIOS of its own, no `/boot/efi`, and doesn't manage its own disk
partitions or kernel — all of these are present here.

---

## Why the conclusion is solid

The decisive distinction between a container and a VM is the **kernel boundary**:

- A **container** shares the host kernel. PID 1 is just a process in a `docker`/`lxc` cgroup,
  there's no boot log, no own kernel, no DMI, and often telltale files like `/.dockerenv` or a
  `container=` env var on PID 1.
- A **VM** boots its own kernel on virtualized hardware. We see exactly that: `systemd-detect-virt`
  reports `kvm` (and `--container none`), `dmesg` shows the KVM boot, the box has its own
  `cloud-amd64` kernel, a partitioned NVMe disk with `/boot/efi`, and DMI says "Amazon EC2".

Every signal points the same way → **Virtual Machine (AWS EC2 / KVM)**.
