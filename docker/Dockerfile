FROM tukiyo3/centos7-ja-systemd
MAINTAINER yuma murata <m.yuma0531@gmail.com>

#system Update & Install packages
RUN yum -y update

# for postgres
RUN yum install -y readline-devel zlib-devel gcc make wget tar && \
    useradd postgres && \
    passwd -f -u postgres && \
    cd /usr/local/src && \
    wget https://ftp.postgresql.org/pub/source/v9.4.5/postgresql-9.4.5.tar.gz && \
    tar zxvf postgresql-9.4.5.tar.gz && \
    cd postgresql-9.4.5 && \
    ./configure --prefix=/usr/local/pgsql-9.4 && \
    make -j 4 && \
    make install && \
    ln -sf /usr/local/pgsql-9.4 /usr/local/pgsql && \
    chown -R postgres:postgres /usr/local/pgsql && \
    cd /usr/local/pgsql && \
    chown -R postgres:postgres ./* && \
    mkdir -p /data/pgdata && \
    chown postgres:postgres /data/pgdata

