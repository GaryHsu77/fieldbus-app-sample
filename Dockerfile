################################################################################
# rootfs
################################################################################
FROM arm32v7/debian:stretch AS rootfs
COPY debs .
RUN apt-get update && apt-get install -y --fix-missing qemu-user-static libjansson-dev libconfig-dev libzmq3-dev libprotobuf-c1 libmosquitto-dev
RUN dpkg -i --force-all ./libmxtagf-dev_1.4.8-1_armhf.deb
RUN dpkg -i ./mxfieldbus_3.4.3-1_armhf.deb
RUN dpkg -i ./mxfieldbus-controller_0.3.1-1_armhf.deb
# =================================
# target
# =================================
FROM arm32v7/debian:stretch

WORKDIR /usr/src/app

COPY --from=rootfs /usr/bin/qemu-arm-static /usr/bin/
COPY --from=rootfs /usr/lib/arm-linux-gnueabihf/libprotobuf-c.so* \
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
COPY --from=rootfs /usr/lib/libmxfb* \
        /usr/lib/
COPY --from=rootfs /usr/bin/fbcontroller /usr/bin/
COPY protocol.json .
COPY entrypoint.sh .
CMD [ "/bin/bash", "./entrypoint.sh" ]
