FROM lsiobase/alpine:3.16 AS downloader

RUN apk --no-cache add wget unzip

ARG TARGETPLATFORM

ARG VERSION=v1.58.1

RUN echo Building for target ${TARGETPLATFORM}

RUN case ${TARGETPLATFORM} in "linux/amd64") ARCH=amd64;; "linux/arm/v7") ARCH=arm-v7;; "linux/arm64") ARCH=arm64;; esac && \
   wget -q https://downloads.rclone.org/${VERSION}/rclone-${VERSION}-linux-${ARCH}.zip && \
   unzip rclone-${VERSION}-linux-${ARCH}.zip && \
   mv rclone-${VERSION}-linux-${ARCH}/rclone /rclone

RUN /rclone version

FROM lsiobase/alpine:3.16

RUN apk add --no-cache gettext fuse

RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

VOLUME /config

COPY --from=downloader /rclone /usr/local/bin/

COPY root/ /
