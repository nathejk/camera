FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y -q curl gphotofs imagemagick && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /mnt/camera
COPY . /camera

CMD /camera/fetch.sh
