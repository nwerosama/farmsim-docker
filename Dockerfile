FROM archlinux:base@sha256:1047e6e7878d58e4ee47e1cd6459a32fab41246b0efc4109e11b7ef16f50b14d
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

ARG USERID=1000 GROUPID=1000
ENV USERID=${USERID} GROUPID=${GROUPID}

ARG WINE_ARCHIVE=https://archive.archlinux.org/packages/w/wine-staging
ARG WINE_PKG=wine-staging-11.9-1-x86_64.pkg.tar.zst

COPY container /

RUN echo -e " \n\
[multilib] \n\
Include = /etc/pacman.d/mirrorlist \n\n\
[options] \n\
IgnorePkg = wine-staging \n\
" >> /etc/pacman.conf

RUN chmod 755 /etc /usr

# download dependencies
RUN pacman-key --init && pacman -Sy --noconfirm supervisor xorg-server-xvfb nettle
RUN --mount=type=cache,target=/root/.cache/winepkg mkdir -p /root/.cache/winepkg && cd /root/.cache/winepkg && curl -sSLO ${WINE_ARCHIVE}/${WINE_PKG} && pacman -U --noconfirm ${WINE_PKG} && pacman -Scc --noconfirm

# setup user account
RUN chsh -s /bin/bash nobody && \
usermod -aG users nobody && \
usermod -ou ${USERID} nobody &>/dev/null && groupmod -og ${GROUPID} users &>/dev/null && \
mkdir -p /home/nobody && chown -R ${USERID}:${GROUPID} /home/nobody && chmod 755 /home/nobody

# cleanup
RUN rm -rf /${WINE_PKG} /var/cache/pacman/{pkg,sync} /usr/share/{man,doc} /var/tmp/* /tmp/* /root/.cache /home/nobody/.cache
RUN find /usr/lib -type f \( -name '*.a' -o -name '*.la' \) -delete && find /usr/share/applications -type f -delete

RUN mv /supervisor.sh /init.sh /root && chmod +x /root/*.sh && chmod +x /home/nobody/*.sh
ENTRYPOINT ["bash", "-c", "/root/init.sh"]
