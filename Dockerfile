FROM debian:buster-slim

ARG snapcast_version=0.24.0
ARG TARGETARCH
ENV HOST snapserver

RUN  apt-get update \
  && apt-get install -y wget ca-certificates \
  && rm -rf /var/lib/apt/lists/*
RUN  wget https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapclient_${snapcast_version}-1_$(echo $TARGETARCH | sed 's/arm/armhf/g').deb
RUN  dpkg -i snapclient_${snapcast_version}-1_$(echo $TARGETARCH | sed 's/arm/armhf/g').deb \
  ;  apt-get update \
  && apt-get -f install -y \
  && rm -rf /var/lib/apt/lists/*
  
RUN  apt-get install -y -f \
  git \
  nano \
  python3 \
  python3-pip \
  libportaudio2 \
  libxcb-xinerama0

RUN mkdir /app

RUN git clone https://github.com/axelcypher/discord-audio-pipe.git \
  && mv discord-audio-pipe \
  && cd /app
  
RUN /usr/bin/snapclient -v
ENTRYPOINT ["/bin/bash","-c","/usr/bin/snapclient -h $HOST"]
