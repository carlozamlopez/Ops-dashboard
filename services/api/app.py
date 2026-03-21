"""
OPS Dashboard — API Service
Genera métricas operacionales dinámicas o las lee desde MySQL.
En dev sin DB usa datos en memoria generados aleatoriamente.
"""
import os
import random
import json
from datetime import datetime, timedelta
from flask import Flask, jsonify

app = Flask(__name__)

SERVICES = ["frontend", "api", "mysql", "aks"]

def generate_metrics():
    """Genera métricas realistas en memoria — no requiere DB."""
    metrics = []
    now = datetime.utcnow()
    for i in range(50):
        service = random.choice(SERVICES)
        metrics.append({
            "id": i + 1,
            "service_name": service,
            "metric_name": random.choice(["response_time_ms", "requests_per_min", "cpu_usage_pct", "memory_usage_pct"]),
            "value": round(random.uniform(5.0, 500.0), 2),
            "unit": "ms",
            "environment": os.getenv("FLASK_ENV", "development"),
            "recorded_at": (now - timedelta(minutes=i*2)).isoformat()
        })
    return metrics

def get_summary(metrics):
    """Agrega métricas por servicio."""
    summary = {}
    for m in metrics:
        svc = m["service_name"]
        if svc not in summary:
            summary[svc] = {"values": [], "service_name": svc}
        summary[svc]["values"].append(m["value"])

    result = []
    for svc, data in summary.items():
        vals = data["values"]
        result.append({
            "service_name": svc,
            "avg_value": round(sum(vals) / len(vals), 2),
            "max_value": round(max(vals), 2),
            "min_value": round(min(vals), 2),
            "total_records": len(vals)
        })
    return result

# ── Intentar conectar a MySQL si está configurado ─────────────
def try_mysql():
    db_host = os.getenv("DB_HOST")
    if not db_host:
        return None
    try:
        import mysql.connector
        conn = mysql.connector.connect(
            host=db_host,
            port=int(os.getenv("DB_PORT", 3306)),
            database=os.getenv("DB_NAME", "opsdb"),
            user=os.getenv("DB_USER", "opsuser"),
            password=os.getenv("DB_PASSWORD", ""),
            ssl_disabled=os.getenv("FLASK_ENV") == "development",
            connection_timeout=3
        )
        return conn
    except Exception:
        return None

@app.route("/api/health")
def health():
    conn = try_mysql()
    if conn:
        conn.close()
        db_status = "connected"
    else:
        db_status = "in-memory mode"

    return jsonify({
        "status": "ok",
        "service": "api",
        "db": db_status,
        "timestamp": datetime.utcnow().isoformat()
    })

@app.route("/api/metrics")
def get_metrics():
    conn = try_mysql()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM metrics ORDER BY recorded_at DESC LIMIT 50")
            metrics = cursor.fetchall()
            cursor.close()
            conn.close()
            return jsonify({"data": metrics, "count": len(metrics), "source": "mysql"})
        except Exception:
            pass

    metrics = generate_metrics()
    return jsonify({"data": metrics, "count": len(metrics), "source": "in-memory"})

@app.route("/api/metrics/summary")
def get_summary_endpoint():
    conn = try_mysql()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute("""
                SELECT service_name,
                       AVG(value) as avg_value,
                       MAX(value) as max_value,
                       MIN(value) as min_value,
                       COUNT(*)   as total_records
                FROM metrics GROUP BY service_name
            """)
            summary = cursor.fetchall()
            cursor.close()
            conn.close()
            return jsonify({"summary": summary, "source": "mysql"})
        except Exception:
            pass

    metrics = generate_metrics()
    return jsonify({"summary": get_summary(metrics), "source": "in-memory"})

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=os.getenv("FLASK_ENV") == "development"
    )