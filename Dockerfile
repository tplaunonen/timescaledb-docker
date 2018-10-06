ARG PG_VERSION
FROM arm32v7/postgres:${PG_VERSION}

MAINTAINER Timescale https://www.timescale.com

ENV TIMESCALEDB_VERSION 1.0.0-rc2

COPY docker-entrypoint-initdb.d/install_timescaledb.sh /docker-entrypoint-initdb.d/
COPY docker-entrypoint-initdb.d/reenable_auth.sh /docker-entrypoint-initdb.d/

RUN set -ex \
    && apt-get update \
    && apt-get -y install \
                ca-certificates \
                libssl-dev \
                wget \
    && mkdir -p /build/timescaledb \
    && wget -O /timescaledb.tar.gz https://github.com/timescale/timescaledb/archive/$TIMESCALEDB_VERSION.tar.gz \
    && tar -C /build/timescaledb --strip-components 1 -zxf /timescaledb.tar.gz \
    && rm -f /timescaledb.tar.gz \
    \
    && apt-get -y install --allow-downgrades \
                dpkg-dev \
                gcc \
                libc6-dev \
                make \
                cmake \
                libpq5=9.6.10-0+deb9u1 \
                postgresql-server-dev-9.6 \
                libpq-dev \
    \
    && cd /build/timescaledb \
    && ./bootstrap -DPROJECT_INSTALL_METHOD="docker" \
    && cd build && make install \
    && cd ~ \
    \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /build \
    && sed -r -i "s/[#]*\s*(shared_preload_libraries)\s*=\s*'(.*)'/\1 = 'timescaledb,\2'/;s/,'/'/" /usr/share/postgresql/postgresql.conf.sample
