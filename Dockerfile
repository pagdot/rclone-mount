FROM lsiobase/alpine:3.11 AS downloader

RUN apk --no-cache add wget unzip

ARG TARGETPLATFORM

ARG VERSION=1.55.1

RUN echo Building for target ${TARGETPLATFORM}

RUN case ${TARGETPLATFORM} in "linux/amd64") ARCH=amd64;; "linux/arm/v7") ARCH=arm-v7;; "linux/arm64") ARCH=arm64;; esac && \
   wget -q https://downloads.rclone.org/v${VERSION}/rclone-v${VERSION}-linux-${ARCH}.zip && \
   unzip rclone-v${VERSION}-linux-${ARCH}.zip && \
   mv rclone-v${VERSION}-linux-${ARCH}/rclone /rclone

RUN /rclone version

FROM lsiobase/alpine:3.14

RUN apk add --no-cache gettext fuse

RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

VOLUME /config

COPY --from=downloader /rclone /usr/local/bin/

COPY root/ /
