# Linux triage runbook

| Signal | Commands | What to check | Common next action |
|---|---|---|---|
| CPU saturation | `uptime; top; ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head` | Runaway process, load vs CPU count | Identify owner; capture evidence before restart |
| Memory pressure | `free -h; vmstat 1 5; dmesg -T | grep -i -E 'oom|killed process'` | Swap, reclaim, OOM events | Inspect heap/container limits and memory growth |
| Disk full | `df -h; df -i; du -xhd1 /var 2>/dev/null | sort -h` | Capacity and inode exhaustion | Rotate/archive logs safely; never delete unknown files |
| Port unavailable | `ss -lntp; curl -v http://127.0.0.1:8085/actuator/health` | Listener, bind address, firewall | Check service logs and config |
| DNS/connectivity | `getent hosts example.com; curl -v --connect-timeout 3 https://example.com` | Resolver, routes, TLS and proxy | Separate DNS, network and certificate errors |
| Service failure | `systemctl status SERVICE; journalctl -u SERVICE -n 100 --no-pager` | Exit code, recent config, permissions | Fix root cause; restart only after validation |
| File permissions | `namei -l /path/to/file; stat /path/to/file` | Every parent directory and owner | Apply least-privilege permissions |
| Archive/log transfer | `tar -czf logs.tgz /path/to/logs; scp logs.tgz user@host:/secure/path/` | Size, access, transfer integrity | Verify checksum on destination |

Use `grep`, `awk`, `sed`, `find` and `tail` to narrow logs. Redact credentials and customer data before sharing evidence.
