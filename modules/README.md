# Modules

Each module is a self-contained, reusable Terraform module — no
environment-specific values here (those live in `environments/dev/`).

- `s3/` — buckets and prefixes for raw/bronze/silver/gold/manifests/checkpoints/errors (`PROJECT_PLAN.md` Section 6), lifecycle policies.
- `iam/` — least-privilege roles: Glue job execution role, orchestrator role, CI/CD deploy role.
- `glue/` — Glue job resources (script location, worker type/count, job bookmarks, timeout).
- `glue-catalog/` — Glue Data Catalog databases and Iceberg table registration (bronze/silver; gold tables are registered by dbt-athena at `dbt run` time, not by Terraform).
- `orchestrator/` — **empty pending [ADR-0001](../../tmbd-analytics/docs/architecture/architecture-decisions/adr-0001-orchestrator-choice.md)**. Will hold either an MWAA environment, or a self-hosted Airflow/Dagster compute stack (ECS/EC2 + networking), once decided.
- `networking/` — VPC/subnets/security groups, only if the orchestrator choice requires them.
- `monitoring/` — CloudWatch log groups, alarms, budget alerts.
