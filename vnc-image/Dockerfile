FROM archlinux:base@sha256:5519bb4afc78843352ea5afb3ea022c76c93b22f6c762c87cdc2b6885860965b
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
