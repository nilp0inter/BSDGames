FROM debian:stable
RUN apt-get update && apt-get install -y libncurses5-dev build-essential wget
WORKDIR /usr/src/game
RUN wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz -O - | tar zx
COPY game /usr/src/game
RUN ./configure && make

FROM debian:stable-slim
RUN apt-get update && apt-get install -y libncurses5
RUN useradd -m hunt
USER hunt
WORKDIR /home/hunt
COPY --from=0 /usr/src/game/hunt/hunt/hunt /home/hunt
COPY --from=0 /usr/src/game/hunt/huntd/huntd /home/hunt
COPY --from=0 /usr/src/game/gotty /home/hunt
COPY gohunt /home/hunt
CMD /home/hunt/gohunt
