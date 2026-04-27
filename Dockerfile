FROM archlinux:multilib-devel@sha256:eb1f8b3bd95dcbdbe602bdc85f2166247b7f096b5a646a19aed205bec6771067
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

ARG USERID=1000 GROUPID=1000
ENV USERID=${USERID} GROUPID=${GROUPID}

ARG WINE_ARCHIVE=https://archive.archlinux.org/packages/w/wine-staging
ARG WINE_PKG=wine-staging-11.7-1-x86_64.pkg.tar.zst

COPY container /

RUN echo -e " \n\
[options] \n\
IgnorePkg = wine-staging \n\
" >> /etc/pacman.conf

RUN chmod 755 /etc /usr

# download dependencies
RUN pacman-key --init && pacman -Sy --noconfirm supervisor xorg-server-xvfb
RUN --mount=type=cache,target=/root/.cache/winepkg mkdir -p /root/.cache/winepkg && cd /root/.cache/winepkg && curl -sSLO ${WINE_ARCHIVE}/${WINE_PKG} && pacman -U --noconfirm ${WINE_PKG} && pacman -Scc --noconfirm

# setup user account
RUN chsh -s /bin/bash nobody && \
usermod -aG users nobody && \
usermod -ou ${USERID} nobody &>/dev/null && groupmod -og ${GROUPID} users &>/dev/null && \
mkdir -p /home/nobody && chown -R ${USERID}:${GROUPID} /home/nobody && chmod 755 /home/nobody

# cleanup
RUN rm -rf /${WINE_PKG} /var/cache/pacman/{pkg,sync} /usr/share/{man,doc} /var/tmp/* /tmp/* /root/.cache /home/nobody/.cache
RUN find /usr/lib -type f -name '*.a' -delete && find /usr/lib -type f -name '*.la' -delete && find /usr/share/applications -type f -delete

RUN mv /supervisor.sh /init.sh /root && chmod +x /root/*.sh
RUN chmod +x /home/nobody/*.sh
ENTRYPOINT ["bash", "-c", "/root/init.sh"]
