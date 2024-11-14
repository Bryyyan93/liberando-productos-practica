FROM python:3.9-alpine3.19

WORKDIR /service/app

COPY requirements.txt .

# Instala las dependencias del sistema necesarias para compilar algunas bibliotecas de Python
RUN apk --no-cache add \
    curl \
    build-base \
    npm \
    libffi-dev \
    openssl-dev \
    python3-dev \
    musl-dev \
    gcc \
    cargo

RUN pip install --upgrade pip
RUN pip install --prefer-binary -r requirements.txt

ADD ./src/ /service/app/

EXPOSE 8081

ENV PYTHONUNBUFFERED 1

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=5 \
    CMD curl -s --fail http://localhost:8081/health || exit 1

CMD ["python3", "-u", "app.py"]