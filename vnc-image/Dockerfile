FROM archlinux:base@sha256:a921b6864609280975d8269df323c2f4f478cdc9d0f5479e70c3fb5e710d1b11
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

# add supervisor conf file
ADD build/supervisor.conf /etc/supervisor.conf
ADD build/rootfs /

# add install bash script
ADD build/install.sh /root/install.sh

# set environment variables for language
ENV LANG=en_US.UTF-8

# install script
##################
RUN chmod +x /root/install.sh && chmod +x /usr/local/bin/xvfb.sh && /bin/bash /root/install.sh

CMD ["/bin/bash", "/usr/local/bin/init.sh"]
