# ============================================================
# WebLogic JDBC DataSource Configuration using WLST
# Project: Enterprise Middleware Platform
# ============================================================

import os

print("====================================================")
print(" Enterprise Middleware Platform - JDBC Configuration")
print("====================================================")

# ------------------------------------------------------------
# WebLogic Configuration
# ------------------------------------------------------------

ADMIN_URL = os.environ.get(
    "ADMIN_URL",
    "t3://localhost:7001"
)

ADMIN_USER = os.environ.get(
    "ADMIN_USER",
    "weblogic"
)

ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD")

if not ADMIN_PASSWORD:
    raise Exception(
        "ADMIN_PASSWORD environment variable is required"
    )

# ------------------------------------------------------------
# PostgreSQL Configuration
# ------------------------------------------------------------

DB_HOST = os.environ.get(
    "DB_HOST",
    "enterprise-postgres"
)

DB_PORT = int(
    os.environ.get(
        "DB_PORT",
        "5432"
    )
)

DB_NAME = os.environ.get(
    "DB_NAME",
    "enterprise_db"
)

DB_USER = os.environ.get(
    "DB_USER",
    "enterprise_user"
)

DB_PASSWORD = os.environ.get("DB_PASSWORD")

if not DB_PASSWORD:
    raise Exception(
        "DB_PASSWORD environment variable is required"
    )

# ------------------------------------------------------------
# JDBC Configuration
# ------------------------------------------------------------

DATASOURCE_NAME = "EnterpriseDB"
JNDI_NAME = "jdbc/EnterpriseDB"
CLUSTER_NAME = "Cluster1"

DRIVER_NAME = "org.postgresql.Driver"

JDBC_URL = (
    "jdbc:postgresql://"
    + DB_HOST
    + ":"
    + str(DB_PORT)
    + "/"
    + DB_NAME
)

# ------------------------------------------------------------
# Connect to WebLogic
# ------------------------------------------------------------

print("")
print("[1] Connecting to WebLogic Administration Server...")

connect(
    ADMIN_USER,
    ADMIN_PASSWORD,
    ADMIN_URL
)

# ------------------------------------------------------------
# Start Edit Session
# ------------------------------------------------------------

print("[2] Starting WebLogic configuration edit session...")

edit()
startEdit()

# ------------------------------------------------------------
# Create JDBC System Resource
# ------------------------------------------------------------

print("[3] Creating JDBC System Resource...")

cd("/")

create(
    DATASOURCE_NAME,
    "JDBCSystemResource"
)

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
)

create(
    DATASOURCE_NAME,
    "JDBCResource"
)

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
)

# ------------------------------------------------------------
# JDBC DataSource Parameters
# ------------------------------------------------------------

print("[4] Configuring JNDI name...")

create(
    "DataSourceParams",
    "JDBCDataSourceParams"
)

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
    + "/JDBCDataSourceParams/DataSourceParams"
)

set(
    "JNDINames",
    JNDI_NAME
)

# ------------------------------------------------------------
# JDBC Driver Parameters
# ------------------------------------------------------------

print("[5] Configuring PostgreSQL JDBC driver...")

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
)

create(
    "DriverParams",
    "JDBCDriverParams"
)

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
    + "/JDBCDriverParams/DriverParams"
)

set("URL", JDBC_URL)
set("DriverName", DRIVER_NAME)

# ------------------------------------------------------------
# JDBC Properties
# ------------------------------------------------------------

print("[6] Configuring database credentials...")

create(
    "Properties",
    "Properties"
)

cd("Properties/Properties")

create(
    "user",
    "Property"
)

cd("Property/user")

set("Value", DB_USER)

cd("../..")

create(
    "password",
    "Property"
)

cd("Property/password")

set("Value", DB_PASSWORD)

# ------------------------------------------------------------
# Connection Pool
# ------------------------------------------------------------

print("[7] Configuring connection pool...")

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
)

create(
    "PoolParams",
    "JDBCConnectionPoolParams"
)

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
    + "/JDBCResource/"
    + DATASOURCE_NAME
    + "/JDBCConnectionPoolParams/PoolParams"
)

set("InitialCapacity", 1)
set("MinCapacity", 1)
set("MaxCapacity", 10)

# ------------------------------------------------------------
# Target DataSource
# ------------------------------------------------------------

print("[8] Targeting DataSource to Cluster1...")

cd(
    "/JDBCSystemResources/"
    + DATASOURCE_NAME
)

set("Targets", CLUSTER_NAME)

# ------------------------------------------------------------
# Save Configuration
# ------------------------------------------------------------

print("[9] Saving WebLogic configuration...")

save()

activate(
    block="true"
)

disconnect()

print("")
print("====================================================")
print(" JDBC DataSource Configuration Completed")
print(" DataSource : " + DATASOURCE_NAME)
print(" JNDI       : " + JNDI_NAME)
print(" JDBC URL   : " + JDBC_URL)
print(" Target     : " + CLUSTER_NAME)
print("====================================================")

exit()
