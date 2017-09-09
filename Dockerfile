FROM alpine:3.6

RUN apk upgrade -U && \
    apk add --update --no-cache \
        bash \
        curl \
        make \
        gphoto2 imagemagick

# Add S6-overlay to use S6 process manager
# https://github.com/just-containers/s6-overlay/#the-docker-way
ARG S6_VERSION=v1.19.1.1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
RUN curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz | tar zxf -

WORKDIR /camera
COPY /rootfs /
COPY . .

ENTRYPOINT ["/init"]
