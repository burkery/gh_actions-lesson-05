FROM alpine:latest

RUN mkdir -p /usr/local/share/ca-certificates/ && \ 
wget -O /usr/local/share/ca-certificates/expd_root_2015.crt http://pki.chq.ei/root-2015.pem && \
wget -O /usr/local/share/ca-certificates/expd_server_2015.crt http://pki.chq.ei/server-2015.pem && \
cat /usr/local/share/ca-certificates/expd_root_2015.crt >> /etc/ssl/certs/ca-certificates.crt && \
cat /usr/local/share/ca-certificates/expd_server_2015.crt >> /etc/ssl/certs/ca-certificates.crt

ENV http_proxy=http://devproxy01.chq.ei:8080
ENV https_proxy=$http_proxy
ENV no_proxy=.ei,.expeditors.com,.local,.test,.internal,localhost,127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.privatelink.westus2.azmk8s.io
ENV HTTP_PROXY=$http_proxy
ENV HTTPS_PROXY=$http_proxy
ENV NO_PROXY=$no_proxy

RUN apk add --no-cache \
        bash           \
        httpie         \
        jq &&          \
        which bash &&  \
        which http &&  \
        which jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sample_push_event.json /sample_push_event.json

ENTRYPOINT ["entrypoint.sh"]
