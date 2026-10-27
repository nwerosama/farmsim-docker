FROM archlinux:base@sha256:e82623936fa1a69700b48e98b058df6eaab18b737c27473a7234a40fdecb9413
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
