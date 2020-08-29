ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine as vanilla

WORKDIR /srv

RUN apk --update add \
    curl \
    git \
    bash \
    build-base \
    libmemcached-dev \
    libxml2-dev \
    zlib-dev \
    autoconf \
    cyrus-sasl-dev \
    libgsasl-dev \
    icu-dev \
    # Install extensions
    && docker-php-ext-install \
        intl \
        opcache \
        bcmath \
        mbstring \
        pdo \
        tokenizer \
        json \
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
    && pecl install -o -f redis \
        &&  rm -rf /tmp/pear \
        &&  docker-php-ext-enable redis

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

FROM vanilla AS composer

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer \
    && chmod +x /usr/bin/composer
