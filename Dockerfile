ARG VERSION=1.16.0

FROM python:3.7-alpine3.16
LABEL maintainer="Kevacoin Project <kevacoin@gmail.com>"

ARG VERSION

COPY ./bin /usr/local/bin

RUN chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/main leveldb-dev && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.16/main rocksdb-dev && \
    pip uninstall Cython &&  pip install Cython==0.29.37 && \
    pip install git+https://github.com/kevacoin-project/python-rocksdb && \
    pip install aiohttp pylru plyvel websockets uvloop && \
    git clone https://github.com/kevacoin-project/electrumx.git && \
    cd electrumx && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV COIN=Kevacoin
ENV DB_DIRECTORY /data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""
ENV REQUEST_SLEEP=1000
ENV INITIAL_CONCURRENT=20
ENV COST_HARD_LIMIT=1000000
ENV PEER_ANNOUNCE=on
ENV DB_ENGINE=rocksdb

WORKDIR /data

EXPOSE 50001 50002 50004 8000

CMD ["init"]
