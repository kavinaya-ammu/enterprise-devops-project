#!/bin/bash

# ============================================================
# ENTERPRISE DEVOPS - HEALTH CHECK + NOTIFICATION
# ============================================================

BASE_DIR="$HOME/enterprise-devops-project"

HEALTH_SCRIPT="$BASE_DIR/enterprise-devops-health-check-v2.sh"
REPORT="/tmp/devops-health-report-v2.txt"

DATE=$(date '+%Y-%m-%d %H:%M:%S')
HOST=$(hostname)

# ------------------------------------------------------------
# Run health check
# ------------------------------------------------------------

"$HEALTH_SCRIPT"

# ------------------------------------------------------------
# Determine overall status
# ------------------------------------------------------------

if grep -q "OVERALL STATUS : ALL SYSTEMS HEALTHY" "$REPORT"; then
    STATUS="HEALTHY"
    EMOJI="🟢"
elif grep -q "OVERALL STATUS : DEGRADED" "$REPORT"; then
    STATUS="DEGRADED"
    EMOJI="🟡"
else
    STATUS="DOWN"
    EMOJI="🔴"
fi

# ------------------------------------------------------------
# Extract summary
# ------------------------------------------------------------

TOTAL=$(grep "Total Checks" "$REPORT" | awk -F: '{print $2}' | xargs)
UP=$(grep "^UP" "$REPORT" | awk -F: '{print $2}' | xargs)
DEGRADED=$(grep "^DEGRADED" "$REPORT" | awk -F: '{print $2}' | xargs)
DOWN=$(grep "^DOWN" "$REPORT" | awk -F: '{print $2}' | xargs)

# ------------------------------------------------------------
# Notification message
# ------------------------------------------------------------

MESSAGE="
$EMOJI ENTERPRISE DEVOPS HEALTH REPORT

Host     : $HOST
Date     : $DATE
Status   : $STATUS

Total Checks : $TOTAL
UP           : ${UP:-0}
DEGRADED     : ${DEGRADED:-0}
DOWN         : ${DOWN:-0}

Report:
$REPORT

Enterprise DevOps Monitoring
"

echo
echo "============================================================"
echo " NOTIFICATION SUMMARY"
echo "============================================================"
echo "$MESSAGE"
echo "============================================================"

# ------------------------------------------------------------
# EMAIL
# ------------------------------------------------------------
#
# We will enable this after SMTP details are configured.
#
# mail -s "$EMOJI Enterprise DevOps Health - $STATUS" \
#      charleswell1984@gamil.com < "$REPORT"


# ------------------------------------------------------------
# WHATSAPP
# ------------------------------------------------------------
#
# We will enable this after WhatsApp API details are configured.
#
# curl -X POST "WHATSAPP_API_URL" ...


exit 0
