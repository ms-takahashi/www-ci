FROM ubuntu:14.04
MAINTAINER shoyan "yamasaki0406@gmail.com"

### PHP
ENV PHP_VERSION 5.6.24

RUN apt-get update && \
    apt-get -y install curl \
                        git \
                        php5 \
                        php5-dev \
                        php5-cli \
                        php5-intl \
                        php-pear \
                        php5-curl \
                        php5-mysql \
                        libmcrypt-dev \
                        libicu-dev \
                        libxml2-dev \
                        openssl \
                        libssl-dev \
                        libcurl4-openssl-dev \
                        bzip2 \
                        libbz2-dev \
                        build-essential \
                        autoconf \
                        automake \
                        libreadline-dev \
                        libxslt1-dev \
                        bison \
                        libpcre3-dev \
                        libjpeg-dev \
                        libpng12-dev \
                        libxpm-dev \
                        libfreetype6-dev \
                        libmysqlclient-dev \
                        libgd-dev

RUN curl -sL http://jp2.php.net/distributions/php-5.6.24.tar.gz -o php-5.6.24.tar.gz
RUN tar zxf php-5.6.24.tar.gz && cd php-5.6.24 && \
    ./configure '--enable-session' \
                '--enable-short-tags' \
                '--with-zlib=/usr' \
                '--with-libdir=lib/x86_64-linux-gnu' \
                '--with-mysql=mysqlnd' \
                '--with-mysqli=mysqlnd' \
                '--with-pdo-mysql=mysqlnd' \
                '--with-mysql-sock=/var/run/mysqld/mysqld.sock' \
                '--with-iconv' \
                '--enable-opcache' \
                '--with-sqlite3' \
                '--with-pdo-sqlite' \
                '--enable-intl' \
                '--enable-libxml' \
                '--enable-simplexml' \
                '--enable-xml' \
                '--enable-xmlreader' \
                '--enable-xmlwriter' \
                '--with-xsl' \
                '--with-libxml-dir=/usr' \
                '--enable-mbstring' \
                '--enable-mbregex' \
                '--enable-bcmath' \
                '--with-bz2=/usr' \
                '--enable-calendar' \
                '--enable-cli' \
                '--enable-ctype' \
                '--enable-dom' \
                '--enable-fileinfo' \
                '--enable-filter' \
                '--enable-shmop' \
                '--enable-sysvsem' \
                '--enable-sysvshm' \
                '--enable-sysvmsg' \
                '--enable-json' \
                '--with-mhash' \
                '--with-mcrypt=/usr' \
                '--enable-pcntl' \
                '--with-pcre-regex' \
                '--with-pcre-dir=/usr' \
                '--enable-pdo' \
                '--enable-phar' \
                '--enable-posix' \
                '--with-readline=/usr' \
                '--enable-sockets' \
                '--enable-tokenizer' \
                '--with-curl=/usr' \
                '--with-openssl=/usr' \
                '--enable-zip' && \
    make && make install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Ruby

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.3.1

RUN apt-get -y install curl \
                        git \
                        wget \
                        build-essential \
                        libssl-dev \
                        libqt4-dev \
                        libqtwebkit-dev \
                        xvfb \
                        dbus \
                        libffi-dev \
                        mysql-client \
                        libxml2-dev \
                        libgcrypt-dev \
                        libxslt-dev \
                        libreadline-dev \
                        chrpath \
                        libxft-dev \
                        libfreetype6 \
                        libfreetype6-dev \
                        libfontconfig1 \
                        libfontconfig1-dev

RUN git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} && \
    git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc

RUN rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION

RUN gem install bundler

# install package for phantomjs
ENV PHANTOMJS_VERSION="phantomjs-1.9.8"
ENV PHANTOMJS="$PHANTOMJS_VERSION-linux-x86_64"
ENV PHANTOMJS_DOWNLOAD_SHA256="a1d9628118e270f26c4ddd1d7f3502a93b48ede334b8585d11c1c3ae7bc7163a"
ENV PHANTOMJS_DOWNLOAD_URL="https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS.tar.bz2"

RUN mkdir -p /tmp/phantomjs && \
    cd /tmp/phantomjs && \
    wget $PHANTOMJS_DOWNLOAD_URL

RUN cd /tmp/phantomjs && \
    echo "$PHANTOMJS_DOWNLOAD_SHA256  /tmp/phantomjs/$PHANTOMJS.tar.bz2" | sha256sum -c - && \
    tar xjf /tmp/phantomjs/$PHANTOMJS.tar.bz2 && \
    ln -snf /tmp/phantomjs/$PHANTOMJS/bin/phantomjs /usr/local/bin/phantomjs
