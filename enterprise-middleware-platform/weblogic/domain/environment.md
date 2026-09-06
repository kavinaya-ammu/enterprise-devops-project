# WebLogic Environment Design

## Environment

Development / QA WebLogic Lab

## Domain

Domain Name:
enterprise_domain

## Administration Server

Name:
AdminServer

Purpose:
Centralized WebLogic administration and configuration.

## Cluster

Cluster Name:
Cluster1

Purpose:
Provide scalability and high availability.

## Managed Servers

ManagedServer1
ManagedServer2
ManagedServer3

Purpose:
Run enterprise Java applications.

## Node Manager

Purpose:
Manage the lifecycle of WebLogic Server instances.

Operations:

- Start
- Stop
- Restart
- Monitor
- Recovery

## Application

Application Name:
enterprise-admin-app

Packaging:
WAR

## Database

Database:
PostgreSQL

Connectivity:
JDBC Data Source

## Target Architecture

WebLogic Domain
 |
 +-- AdminServer
 |
 +-- Cluster1
      |
      +-- ManagedServer1
      +-- ManagedServer2
      +-- ManagedServer3
               |
               v
        enterprise-admin-app
               |
              JDBC
               |
          PostgreSQL
