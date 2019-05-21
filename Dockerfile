################################################################################
# qemu
################################################################################
FROM arm32v7/debian:stretch as qemu
RUN apt-get update && apt-get install qemu-user-static -y
################################################################################
# thingspro
################################################################################
FROM moxaisd/thingspro-dev-base:0.11.0-1-linux-arm AS thingspro
# =================================
# apt install stage
# =================================
FROM arm32v7/debian:stretch

COPY --from=qemu /usr/bin/qemu-arm-static /usr/bin/
COPY --from=thingspro /usr/lib/arm-linux-gnueabihf/libprotobuf-c.so* \
        /usr/lib/arm-linux-gnueabihf/libmosquitto* \
        /usr/lib/arm-linux-gnueabihf/libzmq.so* \
        /usr/lib/arm-linux-gnueabihf/libjansson.so* \
        /usr/lib/arm-linux-gnueabihf/libevent-2.0.so* \
        /usr/lib/arm-linux-gnueabihf/libmxtagf.so* \
        /usr/lib/arm-linux-gnueabihf/libcrypto.so* \
        /usr/lib/arm-linux-gnueabihf/libssl.so* \
        /usr/lib/arm-linux-gnueabihf/libsodium.so* \
        /usr/lib/arm-linux-gnueabihf/libpgm* \
        /usr/lib/arm-linux-gnueabihf/
COPY --from=thingspro /usr/lib/libmxfb* \
        /usr/lib/
COPY debs .
RUN dpkg -i --force-all ./mxfieldbus-controller_0.3.1-1_armhf.deb

WORKDIR /usr/src/app
COPY protocol.json .
COPY entrypoint.sh .
CMD [ "/bin/bash", "./entrypoint.sh" ]
