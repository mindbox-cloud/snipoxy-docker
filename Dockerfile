FROM golang:1.22-bookworm as build

ARG SNIPROXY_VER

WORKDIR /app
RUN git clone https://github.com/ameshkov/sniproxy.git . \
    && git checkout tags/${SNIPROXY_VER} \
    && go mod tidy \
    && go build -o sniproxy

FROM debian:bookworm-slim

ENV PATH=$PATH:/app
ENV SNIPROXY_DNS_V4_REDIRECT=8.8.8.8
ENV SNIPROXY_DNS_UPSTREAM=8.8.8.8
ENV SNIPROXY_EXTRA_ARGS=

RUN apt update \
    && apt install -y curl \
    && apt clean

WORKDIR /app

COPY --from=build /app/sniproxy .

CMD [ "/bin/sh", "-c", "sniproxy --dns-redirect-ipv4-to=${SNIPROXY_DNS_V4_REDIRECT} --dns-upstream=${SNIPROXY_DNS_UPSTREAM} ${SNIPROXY_EXTRA_ARGS}" ]
