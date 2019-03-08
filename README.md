# docker-php-app-base-image

Extend this image in microservices which needs both php-fpm and nginx.

This image has production-ready configuration of php-fpm [inspired by symfony](https://symfony.com/doc/current/setup/web_server_configuration.html) which is suitable for most production workloads. Nginx automatically points all requests to 

## php-fpm setup

```dockerfile
ADD .docker/app/usr/local/etc/php/conf.d/app.ini /usr/local/etc/php/conf.d/app.ini
ADD .docker/app/usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
```

## nginx setup

```dockerfile
ADD .docker/app/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
```
