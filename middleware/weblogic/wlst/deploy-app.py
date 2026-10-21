# WLST online script template. Run with the WLST shipped with your WebLogic installation.
# Inject credentials securely through an approved secret mechanism; do not commit them.
import os
admin_url = os.environ.get('WLS_ADMIN_URL')
username = os.environ.get('WLS_USERNAME')
password = os.environ.get('WLS_PASSWORD')
war_path = os.environ.get('WLS_WAR_PATH', 'application/target/enterprise-wms.war')
app_name = os.environ.get('WLS_APP_NAME', 'enterprise-wms')
if not admin_url or not username or not password:
    raise Exception('Set WLS_ADMIN_URL, WLS_USERNAME and WLS_PASSWORD securely')
connect(username, password, admin_url)
try:
    deploy(app_name, war_path, targets=os.environ.get('WLS_TARGETS', 'AdminServer'), upload='true', timeout=600000)
    state(app_name, 'App')
finally:
    disconnect()
