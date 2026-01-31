from __future__ import annotations

import logging
import os
import random
import time
from typing import Tuple

from datadog import initialize
from datadog.dogstatsd import DogStatsd
from flask import Flask, jsonify, request

SERVICE_NAME = os.getenv("SERVICE_NAME", "sample-api")
ENV = os.getenv("ENV", "dev")
VERSION = os.getenv("VERSION", "0.1.0")
AGENT_HOST = os.getenv("DD_AGENT_HOST", "localhost")
DOGSTATSD_PORT = int(os.getenv("DD_DOGSTATSD_PORT", "8125"))

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger("sample-service")

initialize()
statsd = DogStatsd(host=AGENT_HOST, port=DOGSTATSD_PORT)

app = Flask(__name__)


def _tags() -> list[str]:
    return [f"service:{SERVICE_NAME}", f"env:{ENV}", f"version:{VERSION}"]


def _record_request(path: str, status: int, latency_ms: float) -> None:
    latency_bucket = "lt_300" if latency_ms <= 300 else "gte_300"
    tags = _tags() + [
        f"endpoint:{path}",
        f"status:{status}",
        f"latency_bucket:{latency_bucket}",
    ]
    statsd.increment("demo.requests", tags=tags)
    statsd.histogram("demo.latency_ms", latency_ms, tags=tags)
    if status >= 500:
        statsd.increment("demo.errors", tags=tags)


def _simulate_latency(base_ms: int, jitter_ms: int) -> float:
    delay_ms = base_ms + random.randint(0, jitter_ms)
    time.sleep(delay_ms / 1000.0)
    return float(delay_ms)


@app.after_request
def _after_request(response):
    request_latency_ms = getattr(request, "_latency_ms", None)
    if request_latency_ms is None:
        start_time = getattr(request, "_start_time", time.time())
        request_latency_ms = (time.time() - start_time) * 1000.0
    _record_request(request.path, response.status_code, request_latency_ms)
    return response


@app.before_request
def _before_request():
    request._start_time = time.time()


@app.route("/")
def index():
    latency_ms = _simulate_latency(20, 40)
    request._latency_ms = latency_ms
    logger.info(
        "request path=/ status=200 latency_ms=%s service=%s env=%s version=%s",
        latency_ms,
        SERVICE_NAME,
        ENV,
        VERSION,
    )
    return jsonify(
        {
            "service": SERVICE_NAME,
            "env": ENV,
            "version": VERSION,
            "message": "hello from sample service",
        }
    )


@app.route("/slow")
def slow():
    latency_ms = _simulate_latency(350, 250)
    request._latency_ms = latency_ms
    logger.info(
        "request path=/slow status=200 latency_ms=%s service=%s env=%s version=%s",
        latency_ms,
        SERVICE_NAME,
        ENV,
        VERSION,
    )
    return jsonify({"status": "ok", "latency_ms": latency_ms})


@app.route("/error")
def error():
    latency_ms = _simulate_latency(30, 50)
    request._latency_ms = latency_ms
    logger.error(
        "request path=/error status=500 latency_ms=%s service=%s env=%s version=%s",
        latency_ms,
        SERVICE_NAME,
        ENV,
        VERSION,
    )
    return jsonify({"status": "error"}), 500


@app.route("/health")
def health():
    request._latency_ms = 1.0
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
