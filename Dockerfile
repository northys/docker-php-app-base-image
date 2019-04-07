ARG PHP_VERSION
ARG MCRYPT_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

WORKDIR /srv

RUN apk --update add \
    curl \
    bash \
    build-base \
    libmemcached-dev \
    libmcrypt-dev \
    libxml2-dev \
    zlib-dev \
    autoconf \
    cyrus-sasl-dev \
    libgsasl-dev \
    # Install extensions
    && docker-php-ext-install \
        opcache \
        bcmath \
        mbstring \
        pdo \
        tokenizer \
        xml \
        pcntl \
    # install postgresql support + pdo
    && apk --update add postgresql-dev \
        && docker-php-ext-install pgsql pdo_pgsql \
    # install mysqlsupport + pdo
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && apk --update add libzip-dev \
        && docker-php-ext-configure zip --with-libzip \
        && docker-php-ext-install zip \
    && pecl channel-update pecl.php.net \
        && pecl install mcrypt-${MCRYPT_VERSION} \
    && pecl install -o -f redis \
        &&  rm -rf /tmp/pear \
        &&  docker-php-ext-enable redis \
    # Install composer
    && curl https://getcomposer.org/composer.phar -o /bin/composer \
        && chmod +x /bin/composer

# Setup php-pm
ADD usr/local/etc/php/conf.d/app.ini /usr/local/etc/php/conf.d/app.ini
ADD usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Add docker entrypoint which runs both nginx and php-fpm
ADD opt/docker-entrypoint.bash /opt/

# Install dumb-init, nginx
RUN apk add --update dumb-init nginx \
    && mkdir -p /run/nginx \
    && chmod +x /opt/docker-entrypoint.bash

# Setup nginx
ADD etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# set dumb-init as entrypoint and run both php-fpm and nginx as child process of dumb-init
ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["--", "/opt/docker-entrypoint.bash"]

