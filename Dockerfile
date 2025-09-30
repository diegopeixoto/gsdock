FROM ghcr.io/linuxserver/baseimage-ubuntu:noble
LABEL maintainer "diegopeixoto <diegopeixoto@users.noreply.github.com>"

# Exit container if we cannot assume UID/GID
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
DIRECTORY_CONFIG="/config" \
DIRECTORY_DATA="/data" \
GS_SERVER_USER=abc \
ECHO_PREFIX="[gsdock]"

# Download latest 64-bit release of GoodSync (Linux)
ADD https://www.goodsync.com/download/goodsync-release-x86_64.tar.gz /tmp/goodsync-release-x86_64.tar.gz

RUN \
 echo "**** install gs-server ****" && \
 tar xvzf \
 /tmp/goodsync-release-x86_64.tar.gz \
	-C /usr/bin --strip-components=1 && \
 chmod +x /usr/bin/gs-server && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /


#Make sure all init and service scripts are executable
RUN chmod +x /etc/cont-init.d/*
RUN chmod +x /etc/services.d/*/*

# [PORTS]
# WebUI Port
EXPOSE 11000/tcp
# Main goodsync protocol port, for uploads/downloads
EXPOSE 33333/tcp
# Local Discovery of GS services are done using these 2 ports
EXPOSE 33338/udp
EXPOSE 33339/udp

# [VOLUMES]
# Map /data to host-defined path for backup storage
VOLUME /data
# Map /config to host-defined config storage folder
VOLUME /config
