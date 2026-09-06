# WebLogic Node Manager

## Purpose

Node Manager is a WebLogic utility used to manage the lifecycle of WebLogic Server instances.

## Responsibilities

- Start WebLogic Server instances
- Stop WebLogic Server instances
- Restart WebLogic Server instances
- Monitor server processes
- Support server recovery
- Provide remote lifecycle management

## Relationship With Administration Server

The Administration Server can communicate with Node Manager to perform lifecycle operations on WebLogic Server instances.

## Relationship With Cluster

Node Manager manages the lifecycle of individual WebLogic Server processes.

It does not provide cluster load balancing.

Cluster scalability and high availability are provided by the WebLogic cluster architecture together with appropriate traffic management.

## Important Configuration

Typical Node Manager configuration includes:

- ListenAddress
- ListenPort
- SecureListener
- StartScriptEnabled
- CrashRecoveryEnabled

## Common Port

Node Manager commonly uses port:

5556

This project value is a reference configuration and must be verified against the actual WebLogic environment.

## Troubleshooting

If Node Manager is unavailable:

1. Check Node Manager process.
2. Check Node Manager log.
3. Check listening port.
4. Check host/network connectivity.
5. Check Node Manager configuration.
6. Check credentials/security configuration.
7. Verify Administration Server connectivity.

If a Managed Server fails:

1. Check Managed Server state.
2. Check Managed Server log.
3. Check Node Manager log.
4. Check JVM errors.
5. Check OS resources.
6. Check port availability.
7. Identify root cause.
8. Restart only after understanding the failure.
9. Validate server and application health.
