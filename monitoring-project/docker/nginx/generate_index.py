# docker/nginx/generate_index.py
html = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Monitoring Project</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #1f2937, #111827);
      color: #f9fafb;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
    }
    h1 { font-size: 2.5rem; margin-bottom: 0.5rem; color: #38bdf8; }
    p { font-size: 1.1rem; margin: 0.25rem 0; }
    .card {
      background: #1e293b;
      padding: 2rem;
      border-radius: 1rem;
      box-shadow: 0 8px 16px rgba(0,0,0,0.3);
      max-width: 600px;
      width: 90%;
    }
    .footer { margin-top: 2rem; font-size: 0.9rem; opacity: 0.7; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello World from NGINX 🚀</h1>
    <p>This is a simple web service that we will monitor with <b>Prometheus</b> & <b>Grafana</b>.</p>
    <p>Generated at: <span id="datetime"></span> UTC</p>
  </div>
  <div class="footer">
    Monitoring Project | Docker Container
  </div>

  <script>
    function updateTime() {
      const now = new Date();
      const formatted = now.getUTCFullYear() + "-" +
        String(now.getUTCMonth()+1).padStart(2,'0') + "-" +
        String(now.getUTCDate()).padStart(2,'0') + " " +
        String(now.getUTCHours()).padStart(2,'0') + ":" +
        String(now.getUTCMinutes()).padStart(2,'0') + ":" +
        String(now.getUTCSeconds()).padStart(2,'0');
      document.getElementById("datetime").textContent = formatted;
    }
    setInterval(updateTime, 1000);
    updateTime();
  </script>
</body>
</html>
"""

with open("index.html", "w") as f:
    f.write(html)
