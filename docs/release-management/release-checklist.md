# Release checklist

## Before deployment
- [ ] Change record and business approval recorded.
- [ ] Version, commit SHA, artifact checksum/image digest recorded.
- [ ] Build, unit tests, SonarQube quality gate and Trivy policy pass.
- [ ] Database migration/backward compatibility reviewed.
- [ ] Secret/configuration references and capacity validated.
- [ ] Deployment window, owners, monitoring and rollback artifact confirmed.

## During deployment
- [ ] Deploy to intended environment and confirm rollout.
- [ ] Capture pipeline/build URL and deployment timestamp.
- [ ] Run health, smoke and critical API checks.
- [ ] Review application, middleware and platform logs.

## After deployment
- [ ] Error rate, latency, resource use and DB pool reviewed.
- [ ] Business owner validates critical workflow.
- [ ] Attach evidence and communicate outcome.
- [ ] If rollback criteria are met, stop promotion and restore last known-good artifact.

## Rollback criteria examples
- Health endpoint remains unavailable beyond agreed timeout.
- Critical API smoke test fails.
- 5xx rate or latency exceeds the change's approved threshold.
- Database connectivity or transaction integrity is impaired.
