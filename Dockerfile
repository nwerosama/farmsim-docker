FROM ghcr.io/nwerosama/farmsim-docker-vnc:latest
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

COPY build/rootfs /
COPY build/install.sh /root/install.sh
RUN chown -R nobody:nobody /home/nobody
RUN chmod +x /opt/fs25/*.sh

# Install script
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh

# Expose port for webinterface
EXPOSE 8080/tcp
# Expose ports for the game
EXPOSE 10823/udp
EXPOSE 10823/tcp
