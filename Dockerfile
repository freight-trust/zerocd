FROM alpine

USER root

RUN apk update

RUN \
    echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk update

RUN apk add bash build-base clamav clamav-dev cvechecker unrar linux-headers

RUN \
  apk --no-cache --update add build-base cmake boost-dev git                                                && \
  sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp  && \
  git clone --depth 1 --recursive -b release https://github.com/ethereum/solidity                           && \
  cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1                             && \
  cd /solidity && make solc && install -s  solc/solc /usr/bin                                               && \
  cd / && rm -rf solidity                                                                                   && \
  apk del sed build-base git make cmake gcc g++ musl-dev curl-dev boost-dev                                 && \
  rm -rf /var/cache/apk/*

RUN apk add --no-cache curl


COPY assets /assets

RUN sh /assets/build.sh

CMD ["/bin/bash"]

