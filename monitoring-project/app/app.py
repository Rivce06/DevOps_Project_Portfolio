from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Métricas Prometheus automáticas
metrics = PrometheusMetrics(app)

@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.route("/metrics")
def metrics_endpoint():
    # Flask prometheus_exporter ya expone metrics automáticamente
    return "", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
