# TMDB Data Platform — Infrastructure

Terraform for the TMDB Data Platform. Split from the pipeline repo
([`tmdb-data-platform`](../tmbd-analytics)) — see
[ADR-0003](../tmbd-analytics/docs/architecture/architecture-decisions/adr-0003-two-repo-split.md)
in the pipeline repo for rationale.

## Layout

| Path                        | Purpose |
|------------------------------|---------|
| `modules/s3/`                | Raw/Bronze/Silver/Gold buckets, lifecycle rules, manifests/checkpoints/errors prefixes |
| `modules/iam/`                | Roles and policies for Glue jobs, orchestrator, CI/CD deploy |
| `modules/glue/`               | Glue job definitions, job bookmarks config, worker sizing |
| `modules/glue-catalog/`       | Glue Data Catalog databases (bronze/silver/gold) and Iceberg table registration |
| `modules/orchestrator/`       | Orchestrator infra — shape depends on [ADR-0001](../tmbd-analytics/docs/architecture/architecture-decisions/adr-0001-orchestrator-choice.md) (MWAA vs self-hosted Airflow vs Dagster); currently empty pending that decision |
| `modules/networking/`         | VPC/subnets if the orchestrator choice requires them (MWAA and self-hosted both do; not needed for Dagster Cloud) |
| `modules/monitoring/`         | CloudWatch alarms, log groups, budget alerts |
| `environments/dev/`           | Dev environment composition of the modules above |

## Status

Not yet applied to any AWS account. No resources exist yet — this is
Phase 0 scaffolding only, matching the pipeline repo's current phase.
