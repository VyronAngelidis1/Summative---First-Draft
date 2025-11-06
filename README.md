# TinyTasks (FastAPI + React) — CI/CD to AWS App Runner

A tiny full-stack app you can deploy to AWS with IaC + GitHub Actions. Includes unit, integration, and E2E tests, plus structured logging.

## Quick start (local)

```bash
# 1) run backend + built frontend
pip install -e .
npm --prefix frontend ci && npm --prefix frontend run build
uvicorn backend.app.main:app --reload

# open http://localhost:8000
```

Run tests:
```bash
pytest -q backend/tests
npm --prefix e2e ci
npx --prefix e2e playwright install --with-deps
E2E_BASE_URL=http://localhost:8000 npm --prefix e2e test
```

## Docker (local)
```bash
docker build -t tinytasks:local .
docker run -p 8000:8000 tinytasks:local
# open http://localhost:8000
```

## CI/CD (GitHub Actions → AWS)

1. Create a new GitHub repo and push this project.
2. In AWS, ensure you have:
   - An ECR repo named `tinytasks`
   - App Runner permissions (Terraform here will create the service).
3. Edit placeholders in:
   - `.github/workflows/deploy.yml` → `<YOUR_AWS_ACCOUNT_ID>`
   - `infra/variables.tf` → default OIDC ARN if needed
   - Terraform apply step vars: `github_org`, `github_repo`
4. Commit & push to `main`. CI runs tests; Deploy workflow builds/pushes image and `terraform apply`s to update App Runner.

Outputs:
- `apprunner_service_url` (the live URL)
- CloudWatch logs/metrics available automatically.

## Structure
- `frontend/` React (Vite)
- `backend/` FastAPI API + static serving
- `e2e/` Playwright tests
- `infra/` Terraform (ECR, App Runner, IAM OIDC role)
- `.github/workflows/` CI + Deploy

## Notes
- This uses in-memory storage for demo simplicity. Swap to SQLite or RDS if needed.
- Logging is structured JSON to stdout; in App Runner it goes to CloudWatch Logs.
