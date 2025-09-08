FROM archlinux:base@sha256:fc6a7997e569e600cac7b69ccc322515b72fddbdb388e978faa3c0f12bd13dae
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

# add supervisor conf file
ADD build/supervisor.conf /etc/supervisor.conf
ADD build/rootfs /

# add install bash script
ADD build/install.sh /root/install.sh

# set environment variables for language
ENV LANG=en_US.UTF-8

# install script
RUN chmod +x /root/install.sh && chmod +x /usr/local/bin/xvfb.sh && /bin/bash /root/install.sh

CMD ["/bin/bash", "/usr/local/bin/init.sh"]
