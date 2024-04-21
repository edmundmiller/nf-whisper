# https://gist.github.com/reitzig/6582edd485a5d0a8b68600dab3b0861b
FROM debian:11 AS build

RUN apt-get update \
 && apt-get install -y libsdl2-dev alsa-utils g++ make wget

RUN mkdir /whisper && \
  wget -q https://github.com/ggerganov/whisper.cpp/tarball/master -O - | \
  tar -xz -C /whisper --strip-components 1

WORKDIR /whisper

ARG model
RUN make main stream

FROM debian:11 AS whisper

RUN apt-get update \
 && apt-get install -y libsdl2-dev alsa-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY --from=build /whisper/main /usr/local/bin/whisper
COPY --from=build /whisper/stream /usr/local/bin/stream
