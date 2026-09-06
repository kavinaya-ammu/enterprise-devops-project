# ============================================================
# WebLogic Domain Creation using WLST
# Project: Enterprise Middleware Platform
# ============================================================

import os

print("====================================================")
print(" Enterprise Middleware Platform - WebLogic Domain")
print("====================================================")

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

WL_HOME = os.environ.get("WL_HOME", "/opt/weblogic/wlserver")

DOMAIN_NAME = os.environ.get(
    "DOMAIN_NAME",
    "EnterpriseDomain"
)

DOMAIN_HOME = os.environ.get(
    "DOMAIN_HOME",
    "/opt/weblogic/domains/EnterpriseDomain"
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

ADMIN_SERVER_NAME = "AdminServer"
ADMIN_PORT = 7001

CLUSTER_NAME = "Cluster1"

MANAGED_SERVERS = [
    ("ManagedServer1", 8001),
    ("ManagedServer2", 8002),
    ("ManagedServer3", 8003)
]

TEMPLATE_PATH = (
    WL_HOME +
    "/common/templates/wls/wls.jar"
)

# ------------------------------------------------------------
# Create WebLogic Domain
# ------------------------------------------------------------

print("")
print("[1] Reading WebLogic domain template...")

readTemplate(TEMPLATE_PATH)

# ------------------------------------------------------------
# Configure Administrator
# ------------------------------------------------------------

print("[2] Configuring WebLogic administrator...")

cd("/Security/base_domain/User/" + ADMIN_USER)

cmo.setPassword(ADMIN_PASSWORD)

# ------------------------------------------------------------
# Configure Administration Server
# ------------------------------------------------------------

print("[3] Configuring Administration Server...")

cd("/Servers/" + ADMIN_SERVER_NAME)

set("Name", ADMIN_SERVER_NAME)
set("ListenAddress", "")
set("ListenPort", ADMIN_PORT)

# ------------------------------------------------------------
# Create Cluster
# ------------------------------------------------------------

print("[4] Creating WebLogic cluster...")

create(CLUSTER_NAME, "Cluster")

# ------------------------------------------------------------
# Create Managed Servers
# ------------------------------------------------------------

for server_name, server_port in MANAGED_SERVERS:

    print(
        "[5] Creating " +
        server_name +
        " on port " +
        str(server_port) +
        "..."
    )

    create(server_name, "Server")

    cd("/Servers/" + server_name)

    set("ListenAddress", "")
    set("ListenPort", server_port)
    set("Cluster", CLUSTER_NAME)

# ------------------------------------------------------------
# Write Domain
# ------------------------------------------------------------

print("[6] Writing WebLogic domain...")

writeDomain(DOMAIN_HOME)

# ------------------------------------------------------------
# Close Template
# ------------------------------------------------------------

closeTemplate()

print("")
print("====================================================")
print(" WebLogic Domain Creation Completed")
print(" Domain       : " + DOMAIN_NAME)
print(" Domain Home  : " + DOMAIN_HOME)
print(" Admin Server : " + ADMIN_SERVER_NAME)
print(" Admin Port   : " + str(ADMIN_PORT))
print(" Cluster       : " + CLUSTER_NAME)
print("====================================================")

exit()
