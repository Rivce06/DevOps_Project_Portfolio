FROM python:3.11-slim

# Crear directorio de la app
WORKDIR /app

# Copiar requirements y código
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Exponer puerto
EXPOSE 5000

# Ejecutar la app
CMD ["python", "app.py"]
