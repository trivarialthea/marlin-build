FROM ubuntu:latest

RUN apt update && apt install -y curl build-essential g++ git python3 python3-venv

# Create a non-root user and group
RUN useradd -s /bin/sh -d /home/platformio -m docker
USER root

# Install PlatformIO Core
RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py \
  && python3 get-platformio.py \
  && mkdir -p /usr/local/bin \
  && ln -s ~/.platformio/penv/bin/platformio /usr/local/bin/platformio \
  && ln -s ~/.platformio/penv/bin/pio /usr/local/bin/pio \
  && ln -s ~/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb
ENV PATH=/home/platformio/.platformio/penv/bin:$PATH

# Clone MarlinFirmware repository, checkout latest release tag
WORKDIR /home/platformio
RUN git clone https://github.com/MarlinFirmware/Marlin.git \
  && cd Marlin/ \
  && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

COPY build-marlin.sh .
CMD ["bash", "/home/platformio/build-marlin.sh"]
