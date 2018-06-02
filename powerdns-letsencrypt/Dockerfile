FROM alpine:3.7

LABEL org.opencontainers.image.authors="daniel@megye.si" \
      org.opencontainers.image.source="https://source.developers.google.com/p/personal-201021/r/powerdns-letsencrypt"

RUN apk add --update \
  pdns \
  pdns-backend-sqlite3 \
  sqlite \
  && rm -rf /var/cache/apk/*

EXPOSE 53 53/udp 8081

ADD pdns.conf /etc/pdns/pdns.conf

# Zone config in Bind format
ADD zones/ /etc/pdns/zones/

# Convert Bind zone to sqlite; https://doc.powerdns.com/md/authoritative/backend-generic-sqlite/
ADD schema.sql /etc/pdns
RUN sqlite3 /etc/pdns/powerdns.sqlite3 < /etc/pdns/schema.sql && zone2sql --named-conf=/etc/pdns/zones/zones.conf --gsqlite | sqlite3 /etc/pdns/powerdns.sqlite3 && chown -R pdns:pdns /etc/pdns


ADD docker-entrypoint.sh /
ENTRYPOINT /docker-entrypoint.sh
