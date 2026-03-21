"""
OPS Dashboard — Frontend Service
Sirve la UI del dashboard de métricas operacionales.
Consume la API interna — nunca toca la DB directamente.
"""
import os
import requests
from flask import Flask, render_template, jsonify

app = Flask(__name__)

API_URL = os.getenv("API_URL", "http://localhost:5000")


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/health")
def health():
    return jsonify({"status": "ok", "service": "frontend"})


@app.route("/api/proxy/metrics")
def proxy_metrics():
    """
    Proxy hacia la API.
    El browser no puede llamar a la API directamente
    porque están en diferentes servicios.
    El frontend actúa como intermediario.
    """
    try:
        response = requests.get(
            f"{API_URL}/api/metrics/summary",
            timeout=5
        )
        return jsonify(response.json())
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 503


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=3000,
        debug=os.getenv("FLASK_ENV") == "development"
    )