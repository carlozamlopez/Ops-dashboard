"""
OPS Dashboard — API Service
REST API que expone métricas operacionales desde MySQL.
"""
import os
import mysql.connector
from flask import Flask, jsonify
from datetime import datetime

app = Flask(__name__)


def get_db_connection():
    """
    Conexión a MySQL.
    En Azure las credenciales vienen de Key Vault via env vars.
    En local vienen del docker-compose.yml
    """
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", 3306)),
        database=os.getenv("DB_NAME", "opsdb"),
        user=os.getenv("DB_USER", "opsuser"),
        password=os.getenv("DB_PASSWORD", ""),
        ssl_disabled=os.getenv("FLASK_ENV") == "development"
    )


@app.route("/api/health")
def health():
    """
    Health check — usado por App Gateway y Kubernetes liveness probe.
    Si la DB no conecta, retorna 503 en lugar de 200.
    """
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({
            "status": "ok",
            "service": "api",
            "db": "connected",
            "timestamp": datetime.utcnow().isoformat()
        })
    except Exception as e:
        return jsonify({
            "status": "degraded",
            "service": "api",
            "db": "disconnected",
            "error": str(e)
        }), 503


@app.route("/api/metrics")
def get_metrics():
    """Retorna métricas operacionales desde la DB."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT * FROM metrics ORDER BY recorded_at DESC LIMIT 50"
        )
        metrics = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify({"data": metrics, "count": len(metrics)})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/metrics/summary")
def get_summary():
    """Resumen agregado por servicio para el dashboard."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT
                service_name,
                AVG(value)   as avg_value,
                MAX(value)   as max_value,
                MIN(value)   as min_value,
                COUNT(*)     as total_records
            FROM metrics
            GROUP BY service_name
        """)
        summary = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify({"summary": summary})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=os.getenv("FLASK_ENV") == "development"
    )