# Use Python 3.11 slim image as base
FROM python:3.11-slim-trixie
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install system dependencies and uv
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \   
    && rm -rf /var/lib/apt/lists/*

# Add the application
ADD . /app/

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock /app/

# Set environment variables
ENV UV_SYSTEM_PYTHON=1
ENV PYTHONUNBUFFERED=1
ENV MCP_HOST=0.0.0.0
ENV MCP_PORT=3011

# Install dependencies using uv
RUN uv sync --frozen --no-dev --compile-bytecode

EXPOSE 3011

# Default command runs via smithery
CMD ["uv", "run", "start"]

