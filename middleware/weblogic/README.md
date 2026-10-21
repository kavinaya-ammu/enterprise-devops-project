# Oracle WebLogic middleware track

This folder contains WLST examples and runbook guidance; Oracle binaries, installers, domains, certificates and credentials are deliberately not bundled.

## Prerequisites
- Authorized Oracle WebLogic installation media and entitlement.
- Verify the selected WebLogic release, JDK and OS against Oracle certification documentation.
- Run WLST from the matching WebLogic installation; online scripts need a reachable AdminServer and an authorized account.
- The included application uses Spring Boot 3 / Jakarta APIs and is not compatible with WebLogic 12.2.1.4. For that server, build a separate Java EE `javax.*` WAR module using a certified framework/JDK combination. Alternatively, target a WebLogic release certified for the selected Jakarta application. The WLST templates remain reusable after adapting targets and credentials.

## Suggested operations
1. Create domain using the supported Configuration Wizard or WLST offline.
2. Configure AdminServer, managed servers, machines, Node Manager and cluster.
3. Create JDBC data source using the correct PostgreSQL driver and test the connection pool.
4. Deploy the WAR to a test target and verify application health.
5. Capture deployment plan, artifact checksum, logs and release record.
6. Roll back to the prior immutable artifact if post-deployment checks fail.

Review `wlst/` before use. The examples are templates and require environment-specific validation.
