# Base Image
FROM python:3.11-slim

# Proxy setup
# docker build --build-arg HTTP_PROXY=http://proxy.corp.com:8080

ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG NO_PROXY="localhost,127.0.0.1,host.docker.internal"

ENV http_proxy=${HTTP_PROXY} \
    https_proxy=${HTTPS_PROXY} \
    no_proxy=${NO_PROXY} \
    HTTP_PROXY=${HTTP_PROXY} \
    HTTPS_PROXY=${HTTPS_PROXY} \
    NO_PROXY=${NO_PROXY}


RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
        build-essential \
        portaudio19-dev \
        ffmpeg \
        espeak \
        libsndfile1  \
        curl \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*  

WORKDIR /workspace

RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir \
    transformers \
    datasets \
    soundfile \
    scikit-learn \
    matplotlib

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV OLLAMA_HOST=http://ollama:11434 \
    PYTHONDONTWRITEBYTECODE=1

EXPOSE 8888 8000

CMD ["jupyter", "lab", \
    "--ip=0.0.0.0", \
    "--port=8888", \
    "--NotebookApp.token=", \
    "--NotebookApp.password=", \
    "--allow-root"]


