#!/bin/bash

# ============================================================
# ENTERPRISE DEVOPS PROJECT - MASTER HEALTH CHECK V2
# ============================================================

REPORT="/tmp/devops-health-report-v2.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

TOTAL=0
UP=0
DEGRADED=0
DOWN=0
INFO=0

# ============================================================
# COLORS
# ============================================================

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

# ============================================================
# COUNTER FUNCTIONS
# ============================================================

status_up() {
    echo -e "${GREEN}UP${NC}"
    UP=$((UP + 1))
    TOTAL=$((TOTAL + 1))
}

status_degraded() {
    echo -e "${YELLOW}DEGRADED${NC}"
    DEGRADED=$((DEGRADED + 1))
    TOTAL=$((TOTAL + 1))
}

status_down() {
    echo -e "${RED}DOWN${NC}"
    DOWN=$((DOWN + 1))
    TOTAL=$((TOTAL + 1))
}

status_info() {
    echo -e "${BLUE}INFO${NC}"
    INFO=$((INFO + 1))
}

# ============================================================
# REPORT
# ============================================================

exec > >(tee "$REPORT") 2>&1

echo "============================================================"
echo "       ENTERPRISE DEVOPS PROJECT HEALTH CHECK V2"
echo "============================================================"
echo "Date/Time : $DATE"
echo

# ============================================================
# 1. SYSTEM
# ============================================================

echo "============================================================"
echo " SYSTEM / WSL"
echo "============================================================"

HOSTNAME=$(hostname)
PRIMARY_IP=$(hostname -I | awk '{print $1}')
FQDN=$(hostname -f)
DNS=$(grep nameserver /etc/resolv.conf | awk 'NR==1 {print $2}')
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Hostname       : $HOSTNAME"
echo "Primary IP     : $PRIMARY_IP"
echo "FQDN           : $FQDN"
echo "DNS Server     : $DNS"
echo "Gateway        : $GATEWAY"

if ip route | grep -q '^default'; then
    echo -n "Default Route  : "
    status_up
else
    echo -n "Default Route  : "
    status_down
fi

if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo -n "Internet       : "
    status_up
else
    echo -n "Internet       : "
    status_down
fi

if getent hosts google.com >/dev/null 2>&1; then
    echo -n "DNS Resolution : "
    status_up
else
    echo -n "DNS Resolution : "
    status_down
fi

if curl -I --max-time 5 https://google.com >/dev/null 2>&1; then
    echo -n "HTTPS          : "
    status_up
else
    echo -n "HTTPS          : "
    status_down
fi

echo

# ============================================================
# 2. DOCKER
# ============================================================

echo "============================================================"
echo " DOCKER"
echo "============================================================"

if docker info >/dev/null 2>&1; then

    echo -n "Docker Engine  : "
    status_up

    echo "Docker Version : $(docker version --format '{{.Server.Version}}')"
    echo "Docker Root    : $(docker info --format '{{.DockerRootDir}}')"

    RUNNING=$(docker ps -q | wc -l)

    echo "Running Containers : $RUNNING"

    echo
    echo "Docker Networks:"
    docker network ls --format '  {{.Name}} : {{.Driver}}'

else

    echo -n "Docker Engine  : "
    status_down

fi

echo

# ============================================================
# 3. MINIKUBE
# ============================================================

echo "============================================================"
echo " MINIKUBE"
echo "============================================================"

if minikube status >/dev/null 2>&1; then

    echo -n "Minikube       : "
    status_up

    echo
    minikube profile list

else

    echo -n "Minikube       : "
    status_down

fi

echo

# ============================================================
# 4. KUBERNETES
# ============================================================

echo "============================================================"
echo " KUBERNETES"
echo "============================================================"

if kubectl cluster-info >/dev/null 2>&1; then

    echo -n "API Server     : "
    status_up

else

    echo -n "API Server     : "
    status_down

fi

echo
echo "Nodes:"

kubectl get nodes -o wide 2>/dev/null

echo

# ============================================================
# NODE HEALTH
# ============================================================

NODE_TOTAL=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)
NODE_READY=$(kubectl get nodes --no-headers 2>/dev/null | awk '$2=="Ready"{count++} END{print count+0}')

echo "Node Health : $NODE_READY/$NODE_TOTAL Ready"

if [ "$NODE_TOTAL" -eq 0 ]; then

    echo -n "Node Status : "
    status_down

elif [ "$NODE_READY" -eq "$NODE_TOTAL" ]; then

    echo -n "Node Status : "
    status_up

else

    echo -n "Node Status : "
    status_degraded

fi

echo

# ============================================================
# 5. KUBERNETES DNS
# ============================================================

echo "============================================================"
echo " KUBERNETES DNS"
echo "============================================================"

if kubectl get svc -n kube-system kube-dns >/dev/null 2>&1; then

    echo -n "Kubernetes DNS : "
    status_up

    kubectl get svc -n kube-system kube-dns -o wide

else

    echo -n "Kubernetes DNS : "
    status_down

fi

echo

# ============================================================
# 6. POD HEALTH
# ============================================================

echo "============================================================"
echo " POD HEALTH"
echo "============================================================"

POD_TOTAL=$(kubectl get pods -A --no-headers 2>/dev/null | wc -l)

POD_RUNNING=$(kubectl get pods -A --no-headers 2>/dev/null | \
awk '$4=="Running"{count++} END{print count+0}')

POD_BAD=$(kubectl get pods -A --no-headers 2>/dev/null | \
awk '$4=="CrashLoopBackOff" || $4=="Error" || $4=="Pending" || $4=="ImagePullBackOff" || $4=="ErrImagePull"{count++} END{print count+0}')

echo "Total Pods     : $POD_TOTAL"
echo "Running Pods   : $POD_RUNNING"
echo "Problem Pods   : $POD_BAD"

if [ "$POD_BAD" -gt 0 ]; then

    echo -n "Pod Health     : "
    status_degraded

    echo
    echo "Problem Pods:"
    kubectl get pods -A --no-headers | \
    awk '$4=="CrashLoopBackOff" || $4=="Error" || $4=="Pending" || $4=="ImagePullBackOff" || $4=="ErrImagePull"'

else

    echo -n "Pod Health     : "
    status_up

fi

echo

# ============================================================
# 7. DEVOPS CLI TOOLS
# ============================================================

echo "============================================================"
echo " DEVOPS CLI TOOLS"
echo "============================================================"

check_tool() {

    TOOL="$1"

    if command -v "$TOOL" >/dev/null 2>&1; then

        echo -n "$TOOL : "
        status_up

        "$TOOL" --version 2>/dev/null | head -1

    else

        echo -n "$TOOL : "
        status_down

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
# 8. ENTERPRISE DEVOPS COMPONENTS
# ============================================================

echo "============================================================"
echo " ENTERPRISE DEVOPS COMPONENTS"
echo "============================================================"

# ------------------------------------------------------------
# JBoss
# ------------------------------------------------------------

echo
echo "JBoss EAP"

JBOSS_PODS=$(kubectl get pods -A --no-headers 2>/dev/null | grep -i jboss)

if [ -n "$JBOSS_PODS" ]; then

    echo "$JBOSS_PODS"

    READY=$(echo "$JBOSS_PODS" | awk '$2 ~ /^[0-9]+\/[0-9]+$/ && $2 !~ /^0\/[0-9]+$/' | wc -l)

    if [ "$READY" -gt 0 ]; then
        echo -n "JBoss Status : "
        status_up
    else
        echo -n "JBoss Status : "
        status_degraded
    fi

else

    echo -n "JBoss Status : "
    status_down

fi

# ------------------------------------------------------------
# Argo CD
# ------------------------------------------------------------

echo
echo "Argo CD"

ARGO_TOTAL=$(kubectl get pods -n argocd --no-headers 2>/dev/null | wc -l)

ARGO_READY=$(kubectl get pods -n argocd --no-headers 2>/dev/null | \
awk '$2 ~ /^[0-9]+\/[0-9]+$/ && $2 !~ /^0\/[0-9]+$/' | wc -l)

echo "Pods : $ARGO_READY/$ARGO_TOTAL Ready"

if [ "$ARGO_TOTAL" -eq 0 ]; then

    echo -n "Argo CD Status : "
    status_down

elif [ "$ARGO_READY" -eq "$ARGO_TOTAL" ]; then

    echo -n "Argo CD Status : "
    status_up

else

    echo -n "Argo CD Status : "
    status_degraded

fi

# ------------------------------------------------------------
# Prometheus
# ------------------------------------------------------------

echo
echo "Prometheus"

PROM_TOTAL=$(kubectl get pods -n monitoring --no-headers 2>/dev/null | \
grep -i prometheus | wc -l)

PROM_BAD=$(kubectl get pods -n monitoring --no-headers 2>/dev/null | \
grep -i prometheus | \
awk '$4=="CrashLoopBackOff" || $4=="Error" || $2 ~ /^0\//{count++} END{print count+0}')

echo "Pods : $PROM_TOTAL"
echo "Problem Pods : $PROM_BAD"

if [ "$PROM_TOTAL" -eq 0 ]; then

    echo -n "Prometheus Status : "
    status_down

elif [ "$PROM_BAD" -gt 0 ]; then

    echo -n "Prometheus Status : "
    status_degraded

else

    echo -n "Prometheus Status : "
    status_up

fi

# ------------------------------------------------------------
# Grafana
# ------------------------------------------------------------

echo
echo "Grafana"

GRAFANA=$(kubectl get pods -A --no-headers 2>/dev/null | grep -i grafana)

if [ -n "$GRAFANA" ]; then

    echo "$GRAFANA"

    GRAFANA_READY=$(echo "$GRAFANA" | \
    awk '$2 ~ /^[0-9]+\/[0-9]+$/ && $2 !~ /^0\// && $2 !~ /^[0-9]+\/[0-9]+$/ {count++} END{print count+0}')

    echo -n "Grafana Status : "
    status_up

else

    echo -n "Grafana Status : "
    status_down

fi

# ============================================================
# 9. PROJECT NAMESPACES
# ============================================================

echo
echo "============================================================"
echo " PROJECT NAMESPACES"
echo "============================================================"

kubectl get namespaces

# ============================================================
# 10. FINAL SUMMARY
# ============================================================

echo
echo "============================================================"
echo " FINAL HEALTH SUMMARY"
echo "============================================================"

echo "Total Checks : $TOTAL"
echo "UP            : $UP"
echo "DEGRADED      : $DEGRADED"
echo "DOWN          : $DOWN"
echo "INFO          : $INFO"

echo

if [ "$DOWN" -eq 0 ] && [ "$DEGRADED" -eq 0 ]; then

    echo -e "${GREEN}OVERALL STATUS : ALL SYSTEMS HEALTHY${NC}"

elif [ "$DOWN" -eq 0 ]; then

    echo -e "${YELLOW}OVERALL STATUS : DEGRADED${NC}"

else

    echo -e "${RED}OVERALL STATUS : ATTENTION REQUIRED${NC}"

fi

echo
echo "Report saved to:"
echo "$REPORT"

echo "============================================================"
