# Build frontend
FROM node:20-alpine AS fe
WORKDIR /fe
COPY frontend/ ./
RUN npm ci && npm run build

# Run backend + serve static
FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
COPY pyproject.toml .
RUN pip install --no-cache-dir .
COPY backend/ ./backend/
COPY --from=fe /fe/dist ./frontend/dist
ENV FRONTEND_DIR=/app/frontend/dist
EXPOSE 8000
CMD ["uvicorn", "backend.app.main:app", "--host", "0.0.0.0", "--port", "8000"]
