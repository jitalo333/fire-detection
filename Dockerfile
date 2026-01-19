# ==== SNAP INSTALL ====
ENV SNAP_HOME=/opt/snap

RUN wget https://download.esa.int/step/snap/9.0/installers/esa-snap_all_unix_9_0_0.sh -O /tmp/snap.sh && \
    chmod +x /tmp/snap.sh && \
    /tmp/snap.sh -q -dir ${SNAP_HOME} && \
    rm /tmp/snap.sh

FROM nvcr.io/nvidia/pytorch:22.12-py3
# ==== PIP SETUP ====
RUN python -m pip install --upgrade pip
# INSTALLING IMPORTANT DEPENDENCIES
RUN apt-get update -y
RUN apt-get install -y git
COPY . /tmp/
RUN apt-get update
# ==== BUILDING WORKING DIR ====
WORKDIR /tmp/
ENV PATH=$PATH:~/.local/bin
RUN pip3 install -r requirements.txt
EXPOSE 8880
