FROM ghcr.io/nwerosama/farmsim-docker-vnc:latest
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

COPY build/rootfs /
COPY build/install.sh /root/install.sh
RUN chown -R nobody:nobody /home/nobody
RUN chmod +x /opt/fs25/*.sh

# Install script
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh

ENV WEB_PORT=8080
ENV GAME_PORT=10823

# Expose port for webinterface
EXPOSE ${WEB_PORT}/tcp
# Expose ports for the game
EXPOSE ${GAME_PORT}/udp
EXPOSE ${GAME_PORT}/tcp
