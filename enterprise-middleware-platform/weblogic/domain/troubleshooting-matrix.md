# WebLogic Troubleshooting Matrix

| Problem | First Check |
|---|---|
| AdminServer unavailable | AdminServer process/logs/port 7001 |
| ManagedServer unavailable | ManagedServer process/logs/port |
| Cannot access application | Server state/application deployment |
| Port connection refused | Process + listening port |
| Server starts then stops | WebLogic log + JVM error |
| OutOfMemoryError | JVM heap/logs/GC |
| Stuck threads | WebLogic server health/thread activity |
| JDBC failure | Data Source + connection pool + DB |
| Application deployment failure | Deployment status + server log |
| Node Manager issue | Node Manager process/log |
| Cluster member unavailable | Cluster/server state + network |
| Slow application | JVM + threads + JDBC + application |
