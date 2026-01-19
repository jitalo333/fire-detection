FROM nvcr.io/nvidia/pytorch:22.12-py3

# ==== EVITAR PROMPTS INTERACTIVOS ====
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Santiago
ENV _JAVA_OPTIONS="-Djava.awt.headless=true"

# ==== SYSTEM DEPS (SNAP) ====
RUN apt-get update && apt-get install -y \
    tzdata \
    wget \
    ca-certificates \
    git \
    openjdk-17-jdk \
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

# ==== SNAP SAR MODULES (SIN REFRESH) ====
RUN ${SNAP_HOME}/bin/snap --nosplash --modules --install org.esa.snap.sar

# ==== PIP SETUP ====
RUN python -m pip install --upgrade pip

# ==== WORKDIR ====
WORKDIR /tmp
ENV PATH=$PATH:/root/.local/bin

COPY . /tmp
RUN pip3 install -r requirements.txt

EXPOSE 8880


