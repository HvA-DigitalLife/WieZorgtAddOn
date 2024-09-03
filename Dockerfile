ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Change working directory
WORKDIR /usr/src

# install dependencies
# * installing python and restic
# * self update restic so we can support compressed repositories
# * upgrade pip for latest packages support
# * install python dependencies

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends build-essential python3.10 python3-pip restic pkg-config cmake python3-dev libhdf5-dev \
    && restic self-update \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir -U setuptools wheel \
    && pip3 install --no-cache-dir urllib3 \
    && pip3 install --no-cache-dir schedule \
    && pip3 install --no-cache-dir tensorflow \
    && pip3 install --no-cache-dir numpy \
    && pip3 install --no-cache-dir pandas \
    && pip3 install --no-cache-dir matplotlib \
    && pip3 install --no-cache-dir tabulate \
    && pip3 install --no-cache-dir tensorboardX \
    && pip3 install --no-cache-dir gym \
    && pip3 install --no-cache-dir plotly

# Copy all data in the root folder
WORKDIR /
COPY rootfs /

# fix permissions for services
RUN chmod a+x /etc/s6-overlay/s6-rc.d/scheduler/run
RUN chmod a+x /etc/s6-overlay/s6-rc.d/scheduler/finish
