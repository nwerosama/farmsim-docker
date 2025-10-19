FROM archlinux:base@sha256:0423e31111e93087aef7a46f999a91e892a8d1b49e9de939e3e660e34ce42fe8
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
