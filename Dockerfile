FROM ubuntu:22.04
ARG APP_NAME
ARG VERSION
ARG BUILDDATE
ARG COMMIT
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
RUN echo "I'm building for $TARGETPLATFORM"

# 安装依赖
RUN apt-get update && apt-get -y install \
    libusb-1.0 wget libavahi-compat-libdnssd-dev

# 安装libssl 1.1
RUN cd /tmp \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb \
    && dpkg -i ./libssl1.1_1.1.0g-2ubuntu4_amd64.deb

RUN cd /tmp \
    && wget https://github.com/bitxeno/usbmuxd2/releases/download/v0.0.1/usbmuxd2-ubuntu-x86_64.tar.gz \
    && tar zxf usbmuxd2-ubuntu-x86_64.tar.gz \
    && dpkg -i ./libgeneral_1.0.0-1_amd64.deb \
    && dpkg -i ./libplist_2.3.0-1_amd64.deb \
    && dpkg -i ./libimobiledevice-glue_1.0.0-1_amd64.deb \
    && dpkg -i ./libusbmuxd_2.3.0-1_amd64.deb \
    && dpkg -i ./libimobiledevice_1.3.1-1_amd64.deb \
    && dpkg -i ./usbmuxd2_1.0.0-1_amd64.deb

# 安装anisette-server，用于模拟本机为MacBook
RUN cd /tmp \
    && wget https://github.com/Dadoum/Provision/releases/download/2.1.0/anisette-server-x86_64 \
    && mv anisette-server-x86_64 /usr/bin/anisette-server \
    && chmod +x /usr/bin/anisette-server

# 安装AltStore
RUN cd /tmp \
    && wget https://github.com/NyaMisty/AltServer-Linux/releases/download/v0.0.5/AltServer-x86_64 \
    && mv AltServer-x86_64 /usr/bin/AltServer \
    && chmod +x /usr/bin/AltServer

# 安装tzdata支持更新时区
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt-get -y install tzdata

# 清空apt缓存和临时数据，减小镜像大小
RUN apt-get clean
RUN cd /tmp && rm ./*.deb && rm ./*.tar.gz

# add 指令会自动解压文件
RUN mkdir -p /doc
COPY ./doc/config.yaml.example /doc/config.yaml
COPY ./build/${APP_NAME}-${TARGETOS}-${TARGETARCH} /usr/bin/${APP_NAME}
RUN chmod +x /usr/bin/${APP_NAME}

# lockdown记录移到到/data
RUN rm -rf /var/lib/lockdown && mkdir -p /data/lockdown && ln -s /data/lockdown /var/lib/lockdown
# RUN rm -rf /AltServerData && mkdir -p /data/AltServerData && ln -s /data/AltServerData /AltServerData


# 生成启动脚本
RUN printf '#!/bin/sh \n\n\

mkdir -p /data/lockdown \n\
mkdir -p /data/AltServer \n\

if [ ! -f "/data/config.yaml" ]; then  \n\
    cp /doc/config.yaml /data/config.yaml \n\
fi  \n\

nohup /usr/sbin/usbmuxd & \n\
nohup /usr/bin/anisette-server --adi-path /data/Provision &  \n\

/usr/bin/%s server -p ${SERVICE_PORT:-80} -c /data/config.yaml  \n\
\n\
' ${APP_NAME} >> /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
# docker 启动不了，需要进入 docker 测试时使用本命令
# docker run -it --entrypoint /bin/sh [docker_image]

EXPOSE 80
VOLUME /data