FROM php:7.4-apache

#RUN apt update && apt install -y software-properties-common
#RUN add-apt-repository ppa:ondrej/php && apt update && apt install -y php7.4-mysql
#RUN apt update && apt install -y php7.4-mysqli
RUN docker-php-ext-install mysqli

COPY frontend /var/www/html/
#RUN sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

EXPOSE 80
