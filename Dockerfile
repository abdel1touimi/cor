FROM alpine:latest

LABEL maintainer="github.com/abdel1touimi"

ENV TXADMIN_VERSION="4.17.1" \
    FIVEM_ARTIFACT="5562-25984c7003de26d4a222e897a782bb1f22bebedd"

EXPOSE 40120
EXPOSE 30120
EXPOSE 30110

RUN apk add --no-cache libgcc libstdc++ curl ca-certificates npm unzip wget
RUN mkdir /opt/FiveM
RUN curl https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_ARTIFACT}/fx.tar.xz | tar xJ -C /opt/FiveM
RUN wget https://github.com/tabarra/txAdmin/releases/download/v${TXADMIN_VERSION}/monitor.zip
RUN unzip -o monitor.zip -d /opt/FiveM/alpine/opt/cfx-server/citizen/system_resources/monitor
RUN npm install -g fvm-installer

ENTRYPOINT ["sh", "/opt/FiveM/run.sh"]
