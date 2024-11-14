FROM python:3.9-slim

WORKDIR /service/app

COPY requirements.txt .

# Instala las dependencias del sistema necesarias para compilar algunas bibliotecas de Python
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \  
    libffi-dev \       
    libssl-dev \
    python3-dev \
    cargo  

RUN pip install --upgrade pip
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --prefer-binary -r requirements.txt

ADD ./src/ /service/app/

EXPOSE 8081

# Error obsoleto
# ENV PYTHONUNBUFFERED 1
ENV PYTHONUNBUFFERED=1

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=5 \
    CMD curl -s --fail http://localhost:8081/health || exit 1

CMD ["python3", "-u", "app.py"]