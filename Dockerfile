# DockerHub base image
#
FROM php:5.6.30-apache

# Put App files
COPY www /srv/www/s3browser/www

# Enable required Apache modules
RUN a2enmod \
  rewrite \
  proxy proxy_http headers

# Basic Apache config to serve the S3Browser
COPY etc/apache2/sites-available/000-default.conf \
  /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && echo "if [ 'true' = \"\${S3BROWSER_PROXY_DOWNLOAD}\" ]; then export APACHE_ARGUMENTS='-DS3Proxy'; fi;" >> /etc/apache2/envvars
RUN sed -i 's/\(-DFOREGROUND\)/\1 ${APACHE_ARGUMENTS}/'  /usr/local/bin/apache2-foreground
#CMD ["-DS3Proxy"]
