FROM centos:7
LABEL maintainer="Jonathan M. Wilbur <jonathan@wilbur.space>"

# These are taken directly from the documentation at
# https://wiki.squid-cache.org/SquidFaq/CompilingSquid#CentOS
# openssl-devel and gcc-c++ were not mentioned, but they are needed, too.
RUN yum install -y \
 perl \
 gcc \
 autoconf \
 automake \
 make \
 sudo \
 wget \
 libxml2-devel \
 libcap-devel \
 libtool-ltdl-devel \
 openssl-devel \
 gcc-c++
RUN curl -s http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.27.tar.gz > squid.tar.gz
RUN tar -xvzf squid.tar.gz
WORKDIR /squid-3.5.27

# The choice of configuration options are taken from
# https://wiki.squid-cache.org/SquidFaq/CompilingSquid#CentOS.
# --with-openssl is MANDATORY for this exploit.
# --enable-ssl is MANDATORY for this exploit.
# --enable-ssl-crtd is MANDATORY for this exploit.
# The remaining capabilities were guessed to not be needed.
RUN ./configure \
 --prefix=/usr \
 --includedir=/usr/include \
 --datadir=/usr/share \
 --bindir=/usr/bin \
 --libexecdir=/usr/lib/squid \
 --localstatedir=/usr/lib/squid \
 --localstatedir=/var \
 --sysconfdir=/etc/squid \
 --with-openssl \
 --enable-ssl \
 --enable-ssl-crtd \
 --disable-icap-client \
 --disable-wccp \
 --disable-wccpv2 \
 --disable-snmp \
 --disable-eui \
 --disable-htcp \
 --disable-ident-lookups \
 --disable-ipv6 \
 --without-mit-krb5 \
 --without-heimdal-krb5 \
 --without-libcap
RUN make
RUN make install

RUN touch /var/logs/access.log
RUN touch /var/logs/cache.log
# Squid runs as 'nobody', per http://www.squid-cache.org/Doc/config/cache_effective_user/
RUN chown nobody:nobody /var/logs/access.log
RUN chown nobody:nobody /var/logs/cache.log
# ssl_crtd is the auxiliary executable that generates MITM certificates for
# intercepting HTTPS traffic.
RUN /usr/lib/squid/ssl_crtd -c -s /var/lib/ssl_db
EXPOSE 3128
ENTRYPOINT [ "/usr/sbin/squid", "-f", "/etc/squid/squid.conf", "-NYCd", "1" ]