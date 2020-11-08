FROM debian:stretch-slim

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update && \
    apt-get install -y \
      bison \
      build-essential \
      cmake \
      flex \
      libedit-dev \
      libssl1.0-dev \
      libldap2-dev \
      quilt \
      wget

RUN tar xzf <(wget https://www.shrew.net/download/ike/ike-2.2.1-release.tgz -O -)

COPY patches /patches

RUN cd ike && \
    QUILT_PATCHES=/patches quilt push -a && \
    cmake . \
      -DQTGUI=NO \
      -DNATT=YES \
      -DLDAP=YES \
      -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -DETCDIR:PATH=/etc \
      -DMANDIR:PATH=/usr/share/man \
      -DLIBDIR=/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/ike \
      -DCMAKE_INSTALL_RPATH:UNINITIALIZED=/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE)/ike && \
    make && \
    make install && \
    cp /etc/iked.conf.sample /etc/iked.conf

CMD [ "/usr/sbin/iked", "-F" ]
