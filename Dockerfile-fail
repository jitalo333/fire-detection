FROM nvcr.io/nvidia/pytorch:22.12-py3

# ==== NO INTERACTIVE & TIMEZONE ====
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Santiago
ENV _JAVA_OPTIONS="-Djava.awt.headless=true"

# ==== SYSTEM DEPS ====
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        wget \
        ca-certificates \
        git \
        openjdk-17-jdk \
        libpq-dev gcc python3-dev \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# ==== SNAP INSTALL ====
ENV SNAP_HOME=/opt/snap
ENV PATH=${PATH}:${SNAP_HOME}/bin

RUN wget https://download.esa.int/step/snap/9.0/installers/esa-snap_all_unix_9_0_0.sh -O /tmp/snap.sh && \
    chmod +x /tmp/snap.sh && \
    /tmp/snap.sh -q -dir ${SNAP_HOME} && \
    rm /tmp/snap.sh

# ==== PIP UPGRADE ====
RUN python -m pip install --upgrade pip

# ==== WORKDIR & PATH ====
WORKDIR /tmp
ENV PATH=$PATH:/root/.local/bin

# ==== PYTHON DEPENDENCIES ====
# Primero instalar psycopg2-binary para evitar compilación fallida
RUN pip install --no-cache-dir psycopg2-binary

# Instalar el resto de las dependencias
COPY . /tmp
RUN pip3 install --no-cache-dir -r requirements.txt

# ==== EXPOSE ====
EXPOSE 8880

