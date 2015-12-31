FROM tukiyo3/centos7-ja-systemd
MAINTAINER yuma murata <m.yuma0531@gmail.com>

#system Update & Install packages
RUN yum -y update

# for ssh
RUN yum -y install passwd openssh openssh-server openssh-clients sudo rsync && \
# Create user
    useradd docker && \
    passwd -f -u docker && \

# Set up SSH
    mkdir -p /home/docker/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh && \
    echo /Users/yuma/.ssh/id_rsa.pub > /home/docker/.ssh/authorized_keys && \
    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \
# setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \
# Set up SSHD config
    #sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \

    # PAMを利用するときには下記をオフにしないとSSHログインできない
    # Centos7からPAMをオフにするのが推奨されてないので、下記設定は必須？
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd

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

