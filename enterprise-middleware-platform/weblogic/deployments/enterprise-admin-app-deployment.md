# Enterprise Admin Application Deployment

## Application

Name:
enterprise-admin-app

Artifact:
enterprise-admin-app-1.0.war

Packaging:
WAR

## Target

WebLogic Cluster:
Cluster1

## Managed Servers

ManagedServer1
ManagedServer2
ManagedServer3

## Deployment Strategy

Deploy the application to Cluster1.

The application will therefore be available
on the Managed Servers belonging to the cluster.

## Application Flow

Client
 |
Load Balancer
 |
Cluster1
 |
+-- ManagedServer1
+-- ManagedServer2
+-- ManagedServer3
 |
enterprise-admin-app
 |
JDBC
 |
PostgreSQL

## Validation

After deployment:

1. Verify deployment state
2. Verify Managed Server health
3. Check WebLogic logs
4. Test application URL
5. Validate application functionality
6. Validate JDBC connectivity when database integration is implemented

## Rollback

If deployment causes an issue:

1. Stop/disable affected deployment according to change procedure
2. Restore previous application version
3. Verify Managed Server health
4. Validate application
5. Review logs and identify root cause
