FROM archlinux:multilib-devel@sha256:c52936673f184d8c3bdcebd4fc6d5403514bc18e175d26fa7c3793b72cbb1d6d
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

ARG WINE_ARCHIVE=https://archive.archlinux.org/packages/w/wine-staging
ARG WINE_PKG=wine-staging-10.15-2-x86_64.pkg.tar.zst

COPY container /

RUN echo -e " \n\
[options] \n\
IgnorePkg = wine-staging \n\
" >> /etc/pacman.conf

RUN chmod 755 /etc /usr

# download dependencies
RUN pacman-key --init && pacman -Syu --noconfirm supervisor xorg-server-xvfb ttf-dejavu moreutils net-tools vim
RUN curl -sSLO ${WINE_ARCHIVE}/${WINE_PKG} && pacman -U --noconfirm ${WINE_PKG} && pacman -Scc --noconfirm

# setup user account
RUN chsh -s /bin/bash nobody && \
usermod -aG users nobody && \
usermod -ou 1000 nobody &>/dev/null && groupmod -og 1000 users &>/dev/null && \
mkdir -p /home/nobody && chown -R nobody:users /home/nobody && chmod 775 /home/nobody

# cleanup
RUN rm -rf /${WINE_PKG} /var/cache/pacman/{pkg,sync} /usr/share/{man,doc} /var/tmp/* /tmp/* /root/.cache /home/nobody/.cache
RUN find /usr/lib -type f -name '*.a' -delete && find /usr/lib -type f -name '*.la' -delete && find /usr/share/applications -type f -delete

RUN mv /supervisor.sh /init.sh /root && chmod +x /root/*.sh
RUN chmod +x /home/nobody/*.sh
ENTRYPOINT ["/bin/bash", "/root/init.sh"]
