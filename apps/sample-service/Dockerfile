FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV SERVICE_NAME=sample-api \
    ENV=dev \
    VERSION=0.1.0 \
    DD_AGENT_HOST=datadog-agent \
    DD_DOGSTATSD_PORT=8125

EXPOSE 8080

CMD ["python", "app.py"]
