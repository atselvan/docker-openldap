FROM centos:7

LABEL authors="Allan Selvan <allantony2008@gmail.com>"
LABEL version=""
LABEL description="Docker container for Openldap"

ENV OPENLDAP_VERSION='2.4.45' \
    INSTALL_PATH="/opt/openldap" \
    DATA_PATH="/data/openldap" \
    BDB_BASE_VERSION='4.8' \
    BDB_VERSION='4.8.30'\
    CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include" \
    LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib" \
    LD_LIBRARY_PATH="/usr/local/BerkeleyDB.4.8/lib/"

RUN set -x\
    && yum update -y \
    && yum install unzip gcc gcc-c++ make -y groff

# Installing berkeley db
RUN set -x \
    && curl -o db-${BDB_VERSION}.zip -fSL http://download.oracle.com/berkeley-db/db-${BDB_VERSION}.zip \
    && unzip db-${BDB_VERSION}.zip \
    && cd ./db-${BDB_VERSION}/build_unix \
    && ../dist/configure --enable-cxx \
    && make \
    && make install

# Installing OpenLDAP
RUN set -x \
    && curl -o openldap-${OPENLDAP_VERSION}.tgz -fSL https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz \
    && tar -xzvf openldap-${OPENLDAP_VERSION}.tgz \
    && ls -lrt \
    && ./openldap-${OPENLDAP_VERSION}/configure --prefix="${INSTALL_PATH}" \
    --enable-slapd \
    --enable-bdb \
    --enable-overlays \
    --enable-syslog \
    --enable-accesslog \
    --enable-auditlog \
    --enable-dynlist \
    --enable-ppolicy \
    --enable-memberof \
    --enable-constraint \
    --enable-debug \
    && make depend \
    && make \
    && make install

WORKDIR ${INSTALL_PATH}

# Creating config db, run and data directories
RUN mkdir ./etc/openldap/slapd.d \
    && mkdir ./run \
    && mkdir /data \
    && mkdir /data/openldap

COPY slapd.conf ./etc/openldap

COPY run.sh ./bin/

VOLUME /data/openldap

RUN chmod a+x ./bin/run.sh

EXPOSE 10389

ENTRYPOINT [ "./bin/run.sh" ]