FROM  ubuntu:groovy-20200704

# How to make dynamic user:
#   https://jtreminio.com/blog/running-docker-containers-as-current-host-user/

# These args are set in Makefile command "build-docker-image".
# They're set to the user & group IDs of whoever (on the host) is building this docker image.
ARG USER_ID
ARG GROUP_ID

# This is standard way to setup ubuntu noninteractive installs for Docker.
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    gettext \
    git \
    lame \
    make \
    mpv \
    npm \
    perl \
    portaudio19-dev \
    python3 \
    python3-venv \
    ripgrep \
    rsync \
    unzip \
    wget \
    ;
RUN rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip \
 && unzip protoc-3.11.4-linux-x86_64.zip -d /usr/local/ -x readme.txt

COPY ./rustup.sh ./
RUN sh ./rustup.sh -y

# For developer builds, this dynamically sets up user "appuser" to have the
# same user and group IDs as whoever (on the host) is building this Docker
# image.
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
     groupadd -g ${GROUP_ID} appuser \
  && useradd -l -u ${USER_ID} -g appuser appuser \
  && mkdir /home/appuser \
  && chown -R appuser:appuser /home/appuser \
  && cp -R ${HOME}/.cargo /home/appuser/ \
  && chown -R appuser:appuser /home/appuser/.cargo \
;fi

USER appuser

CMD sh ./docker-build-command.sh
