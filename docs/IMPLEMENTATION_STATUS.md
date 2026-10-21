# Implementation status and boundaries

Included in this bundle: Spring Boot API source and tests, Maven build, container build, Compose, Kubernetes/OpenShift examples, Jenkins pipeline, Ansible examples, Terraform AWS starter, WebLogic WLST templates, Prometheus/Grafana examples, and runbooks.

Not automatically completed by generating files: local build/test execution, registry publication, cluster deployment, SonarQube server setup/quality-gate token, AWS apply, Oracle WebLogic installation, real database integration testing, and end-to-end production release validation. These require your local environment, credentials, platform versions and explicit approvals.

The app's sample customer/inventory endpoints are in-memory demo data. The PostgreSQL profile configures a PostgreSQL datasource, but this initial API does not persist customer or inventory records to PostgreSQL yet. The default profile uses H2 so the application can start without an external database. Treat database schema/repository integration as a follow-on implementation task, not as a completed database-backed business layer.
