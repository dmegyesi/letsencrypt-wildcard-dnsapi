FROM google/cloud-sdk:alpine

LABEL org.opencontainers.image.authors="daniel@megye.si" \
      org.opencontainers.image.source="https://source.developers.google.com/p/personal-201021/r/dehydrated-client"

RUN apk add --update openssl

# Letsencrypt client
ADD https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated /usr/local/bin/dehydrated

# DNS API hook for PowerDNS
ADD https://raw.githubusercontent.com/silkeh/pdns_api.sh/master/pdns_api.sh /usr/local/bin/pdns_api.sh

RUN chmod +x /usr/local/bin/*

RUN git config --global push.default simple && \
 git config --global user.name dehydrated && \
 git config --global user.email dehydrated@megye.si

ADD sa-dehydrated-git-key.json /root/
RUN gcloud auth activate-service-account --key-file /root/sa-dehydrated-git-key.json && \
    gcloud config set project personal-201021 && \
    gcloud source repos clone dehydrated-data /etc/dehydrated


ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
