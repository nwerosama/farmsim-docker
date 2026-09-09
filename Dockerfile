FROM archlinux:base@sha256:b944cc65c5f28665dfd5fdbf5ed2997c88f5bb4a0aefac7ee8a7ef01893e5ed9
LABEL org.opencontainers.image.source="https://github.com/nwerosama/farmsim-docker"

ARG USERID=1000 GROUPID=1000
ENV USERID=${USERID} GROUPID=${GROUPID}

RUN echo -e " \n\
  [multilib] \n\
  Include = /etc/pacman.d/mirrorlist \
  " >> /etc/pacman.conf

ARG PROTON_RT=GE-Proton11-6
ARG PROTON_FILE=${PROTON_RT}.tar.gz
ARG PROTON_ARCHIVE=https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${PROTON_RT}/${PROTON_FILE}

RUN chmod 755 /etc /usr

# download dependencies
RUN pacman-key --init && pacman -Sy --noconfirm supervisor xorg-server-xvfb nettle mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader
RUN --mount=type=cache,target=/root/.cache/proton-ge mkdir -p /root/.cache/proton-ge /opt/proton && cd /root/.cache/proton-ge && \
  [ -f "${PROTON_FILE}" ] || \
  curl -fsSLO ${PROTON_ARCHIVE} && tar -xf ${PROTON_FILE} -C /opt/proton
RUN ln -sfn "/opt/proton/${PROTON_RT}" /opt/proton/current

# setup user account
RUN chsh -s /bin/bash nobody && \
  usermod -aG users nobody && \
  usermod -ou ${USERID} nobody &>/dev/null && groupmod -og ${GROUPID} users &>/dev/null && \
  mkdir -p /home/nobody && chown -R ${USERID}:${GROUPID} /home/nobody && chmod 755 /home/nobody

# cleanup
RUN rm -rf /var/cache/pacman/{pkg,sync} /usr/share/{man,doc} /var/tmp/* /tmp/* /root/.cache /home/nobody/.cache && pacman -Scc --noconfirm
RUN find /usr/lib -type f \( -name '*.a' -o -name '*.la' \) -delete && find /usr/share/applications -type f -delete

COPY container /

RUN mv /supervisor.sh /init.sh /root && chmod +x /root/*.sh && chmod +x /home/nobody/*.sh
ENTRYPOINT ["bash", "-c", "/root/init.sh"]
