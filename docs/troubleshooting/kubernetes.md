# Kubernetes/OpenShift troubleshooting

1. `kubectl -n enterprise-wms get pods -o wide` / `oc get pods`.
2. `kubectl -n enterprise-wms describe pod POD` / `oc describe pod POD`.
3. `kubectl -n enterprise-wms logs POD --previous` for a crashed container.
4. `kubectl -n enterprise-wms get events --sort-by=.lastTimestamp`.
5. Check image name/pull secret, requests vs available capacity, probes, environment variables, service selectors, DNS and network policy.

- **CrashLoopBackOff:** inspect current and previous logs, exit code and configuration; do not just increase restart count.
- **ImagePullBackOff:** validate tag/digest, registry reachability and pull credentials.
- **Pending:** inspect scheduler events, resource requests, node capacity, taints and PVC binding.
- **OOMKilled:** compare container memory limit with JVM/container heap; set appropriate memory limits and JVM sizing.
- **Probe failures:** verify path, port, startup duration and application readiness dependencies.
- **Service unreachable:** compare Service selectors with pod labels; inspect EndpointSlices and DNS.
- **PVC Pending:** check StorageClass and access mode; do not assume a default storage class exists.
- **RBAC denied:** use `kubectl auth can-i` or `oc auth can-i`; grant only the minimum required permission.
