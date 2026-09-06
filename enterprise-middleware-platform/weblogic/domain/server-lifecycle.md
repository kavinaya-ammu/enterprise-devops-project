# WebLogic Server Lifecycle

## Domain

Domain:
enterprise_domain

## Server Startup Order

Recommended startup sequence:

1. Start Node Manager
2. Start Administration Server
3. Verify Administration Server health
4. Start Managed Servers
5. Verify Managed Server health
6. Verify Cluster1
7. Verify application deployment

## Startup Architecture

Node Manager
      |
      v
AdminServer
      |
      v
Managed Servers
      |
      +-- ManagedServer1
      +-- ManagedServer2
      +-- ManagedServer3

## Shutdown Order

1. Stop application traffic according to change procedure
2. Stop Managed Servers
3. Stop Administration Server
4. Stop Node Manager if required

## Managed Server Recovery

If a Managed Server becomes unavailable:

1. Check server state
2. Check Managed Server log
3. Check Node Manager log
4. Check JVM status/errors
5. Check operating-system resources
6. Check port availability
7. Identify root cause
8. Restart server if appropriate
9. Verify server health
10. Verify application health
11. Confirm cluster health

## Important Principle

Node Manager manages the lifecycle of WebLogic Server processes.

Node Manager does not itself provide application load balancing or cluster high availability.

Clustering and load balancing provide application scalability and high availability.
