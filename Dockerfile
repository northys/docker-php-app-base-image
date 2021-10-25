ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm AS vanilla

WORKDIR /srv

RUN apt-get update

RUN apt-get install -y \
    git \
    curl \
    bash \
    build-essential \
    libxml2-dev \
    autoconf \
    libicu-dev \
    # postgresql deps
    libpq-dev \
    # zip deps
    libzip-dev \
    # mbstring deps
    libonig-dev \
    # gd deps
    libwebp-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    # Configure extensions
    && bash -c 'if [[ "$PHP_VERSION" == *"7.4"* ]]; then docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg; else docker-php-ext-configure gd --with-freetype-dir=/usr/lib/ --with-png-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ --with-webp-dir=/usr/lib/ --with-gd; fi;' \
    # Install extensions
    && docker-php-ext-install \
        intl \
        opcache \
        bcmath \
        mbstring \
        pdo \
        json \
        xml \
        pcntl \
        gd \
        pgsql pdo_pgsql \
        mysqli pdo_mysql \
    && docker-php-ext-configure zip && docker-php-ext-install zip \
    && pecl install -o -f redis \
        && rm -rf /tmp/pear \
        && docker-php-ext-enable redis

# Setup php-pm
ADD usr/local/etc/php/conf.d/app.ini /usr/local/etc/php/conf.d/app.ini
ADD usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Add docker entrypoint which runs both nginx and php-fpm
ADD opt/docker-entrypoint.bash /opt/

# Install dumb-init, nginx
RUN apt-get install -y dumb-init nginx \
    && mkdir -p /run/nginx \
    && chmod +x /opt/docker-entrypoint.bash

# Setup nginx
ADD etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default
RUN sed -i 's/\# server_tokens/server_tokens/g' /etc/nginx/nginx.conf

# set dumb-init as entrypoint and run both php-fpm and nginx as child process of dumb-init
ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["--", "/opt/docker-entrypoint.bash"]

FROM vanilla AS composer

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
