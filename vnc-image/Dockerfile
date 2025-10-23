FROM archlinux:base@sha256:c136b06a4f786b84c1cc0d2494fabdf9be8811d15051cd4404deb5c3dc0b2e57
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

# add supervisor conf file
ADD build/supervisor.conf /etc/supervisor.conf
ADD build/rootfs /

# add install bash script
ADD build/install.sh /root/install.sh

# set environment variable for language
ENV LANG=en_US.UTF-8

# install script
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh

# set port for vnc server to listen on
ENV VNC_PORT=5900

CMD ["/bin/bash", "/usr/local/bin/init.sh"]
