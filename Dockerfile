# Use official Python runtime as a parent image
FROM python:3.11-slim

# Set working directory for the application
WORKDIR /app

# Install Python dependencies first to leverage Docker cache
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code into the container
COPY app.py app.py

# Create a non-root user and switch to it
RUN useradd -m appuser
USER appuser

# Expose the application's port
EXPOSE 5000

# Add a healthcheck (adapte la route /health si nécessaire)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Default command to run the app using gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
