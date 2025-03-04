
# Copy and changed based on https://github.com/gmr/alpine-pgbouncer/blob/master/Dockerfile

FROM alpine:3.21 AS build
ARG VERSION=1.24.0

RUN apk add --no-cache autoconf autoconf-doc automake curl gcc git libc-dev libevent-dev libtool make openssl-dev pandoc pkgconfig

RUN curl -sS -o /pgbouncer.tar.gz -L https://pgbouncer.github.io/downloads/files/$VERSION/pgbouncer-$VERSION.tar.gz && \
  tar -xzf /pgbouncer.tar.gz && mv /pgbouncer-$VERSION /pgbouncer

RUN cd /pgbouncer && ./configure --prefix=/usr && make

FROM alpine:3.21

RUN apk add --no-cache busybox libevent postgresql-client && \
  mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
  chown -R postgres /var/log/pgbouncer /var/run/pgbouncer /etc/pgbouncer

COPY --from=build /pgbouncer/pgbouncer /usr/bin
COPY ./config /etc/pgbouncer/

RUN sed -i 's/logfile = \/var\/log\/pgbouncer\/pgbouncer.log/; logfile = \/var\/log\/pgbouncer\/pgbouncer.log/' /etc/pgbouncer/pgbouncer.ini

USER postgres
VOLUME /etc/pgbouncer
EXPOSE 5432

CMD ["/usr/bin/pgbouncer", "-v", "/etc/pgbouncer/pgbouncer.ini"]
