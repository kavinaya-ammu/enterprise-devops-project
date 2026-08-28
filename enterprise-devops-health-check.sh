#!/bin/bash

# ============================================================
# ENTERPRISE DEVOPS PROJECT - MASTER HEALTH CHECK
# ============================================================

REPORT="/tmp/devops-health-report.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

TOTAL=0
UP=0
DOWN=0

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

check_result() {
    local name="$1"
    local result="$2"

    TOTAL=$((TOTAL + 1))

    if [ "$result" -eq 0 ]; then
        echo "  $name : UP"
        UP=$((UP + 1))
    else
        echo "  $name : DOWN"
        DOWN=$((DOWN + 1))
    fi
}

# Start report
exec > >(tee "$REPORT") 2>&1

echo "============================================================"
echo "       ENTERPRISE DEVOPS PROJECT HEALTH CHECK"
echo "============================================================"
echo "Date/Time : $DATE"
echo

# ============================================================
# 1. SYSTEM INFORMATION
# ============================================================

echo "============================================================"
echo " SYSTEM / WSL"
echo "============================================================"

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
FQDN=$(hostname -f)
DNS=$(grep nameserver /etc/resolv.conf | awk 'NR==1 {print $2}')
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Hostname       : $HOSTNAME"
echo "Primary IP     : $IP"
echo "FQDN           : $FQDN"
echo "DNS Server     : $DNS"
echo "Gateway        : $GATEWAY"

# ------------------------------------------------------------
# Network Health
# ------------------------------------------------------------

if ip route | grep -q '^default'; then
    check_result "Default Route" 0
else
    check_result "Default Route" 1
fi

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    check_result "Internet Connectivity" 0
else
    check_result "Internet Connectivity" 1
fi

if getent hosts google.com >/dev/null 2>&1; then
    check_result "DNS Resolution" 0
else
    check_result "DNS Resolution" 1
fi

if curl -I --max-time 5 https://google.com >/dev/null 2>&1; then
    check_result "HTTPS Connectivity" 0
else
    check_result "HTTPS Connectivity" 1
fi

# ============================================================
# 2. DOCKER
# ============================================================

echo "============================================================"
echo " DOCKER"
echo "============================================================"

if docker info >/dev/null 2>&1; then
    check_result "Docker Engine" 0
    echo "  Docker Version : $(docker version --format '{{.Server.Version}}')"
    echo "  Docker Root    : $(docker info --format '{{.DockerRootDir}}')"
else
    check_result "Docker Engine" 1
fi

RUNNING_CONTAINERS=$(docker ps -q 2>/dev/null | wc -l)

echo "  Running Containers : $RUNNING_CONTAINERS"

echo
echo "  Docker Networks:"
docker network ls --format '  {{.Name}} : {{.Driver}}'

echo

# ============================================================
# 3. MINIKUBE
# ============================================================

echo "============================================================"
echo " MINIKUBE"
echo "============================================================"

if minikube status >/dev/null 2>&1; then
    check_result "Minikube" 0
else
    check_result "Minikube" 1
fi

echo "  Profiles:"
minikube profile list 2>/dev/null

echo

# ============================================================
# 4. KUBERNETES
# ============================================================

echo "============================================================"
echo " KUBERNETES"
echo "============================================================"

if kubectl cluster-info >/dev/null 2>&1; then
    check_result "Kubernetes API Server" 0
else
    check_result "Kubernetes API Server" 1
fi

echo
echo "  Nodes:"
kubectl get nodes -o wide 2>/dev/null

echo
echo "  Pods:"
kubectl get pods -A -o wide 2>/dev/null

echo
echo "  Services:"
kubectl get svc -A 2>/dev/null

echo

# ============================================================
# 5. KUBERNETES DNS
# ============================================================

echo "============================================================"
echo " KUBERNETES DNS"
echo "============================================================"

if kubectl get svc -n kube-system kube-dns >/dev/null 2>&1; then
    check_result "Kubernetes DNS" 0
    kubectl get svc -n kube-system kube-dns -o wide
else
    check_result "Kubernetes DNS" 1
fi

echo

# ============================================================
# 6. DEVOPS COMMAND-LINE TOOLS
# ============================================================

echo "============================================================"
echo " DEVOPS CLI TOOLS"
echo "============================================================"

check_tool() {
    local tool="$1"

    if command -v "$tool" >/dev/null 2>&1; then
        check_result "$tool" 0
        "$tool" --version 2>/dev/null | head -1
    else
        check_result "$tool" 1
    fi
}

check_tool git
check_tool java
check_tool mvn
check_tool docker
check_tool kubectl
check_tool minikube
check_tool helm
check_tool trivy
check_tool terraform
check_tool ansible

echo

# ============================================================
# 7. IMPORTANT KUBERNETES NAMESPACES
# ============================================================

echo "============================================================"
echo " PROJECT NAMESPACES"
echo "============================================================"

kubectl get namespaces 2>/dev/null

echo

# ============================================================
# 8. IMPORTANT APPLICATION COMPONENTS
# ============================================================

echo "============================================================"
echo " ENTERPRISE DEVOPS COMPONENTS"
echo "============================================================"

echo
echo "JBoss EAP:"
kubectl get pods -A -o wide 2>/dev/null | grep -i jboss || echo "  No JBoss pod detected"

echo
echo "Jenkins:"
kubectl get pods -A -o wide 2>/dev/null | grep -i jenkins || echo "  No Jenkins pod detected"

echo
echo "SonarQube:"
kubectl get pods -A -o wide 2>/dev/null | grep -i sonar || echo "  No SonarQube pod detected"

echo
echo "Nexus:"
kubectl get pods -A -o wide 2>/dev/null | grep -i nexus || echo "  No Nexus pod detected"

echo
echo "Argo CD:"
kubectl get pods -n argocd -o wide 2>/dev/null

echo
echo "Prometheus:"
kubectl get pods -A -o wide 2>/dev/null | grep -i prometheus || echo "  No Prometheus pod detected"

echo
echo "Grafana:"
kubectl get pods -A -o wide 2>/dev/null | grep -i grafana || echo "  No Grafana pod detected"

echo

# ============================================================
# 9. FINAL SUMMARY
# ============================================================

echo "============================================================"
echo " FINAL HEALTH SUMMARY"
echo "============================================================"

echo "Total Checks : $TOTAL"
echo "UP            : $UP"
echo "DOWN          : $DOWN"

if [ "$DOWN" -eq 0 ]; then
    echo
    echo "OVERALL STATUS : ALL SYSTEMS HEALTHY"
else
    echo
    echo "OVERALL STATUS : ATTENTION REQUIRED"
fi

echo
echo "Report saved to:"
echo "$REPORT"

echo "============================================================"
