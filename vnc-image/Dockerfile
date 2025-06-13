FROM archlinux:base@sha256:d2094076ea97044f0a0d7e8ea7ce025cc4fb9409b3bd5c4749c21728c204d490
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
