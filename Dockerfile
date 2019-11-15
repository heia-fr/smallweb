FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y nginx php5-fpm sshfs

ADD default /etc/nginx/sites-available/default
ADD default-lb /default-lb
ADD test.php /usr/share/nginx/html/test.php

# Add nginx daemon to runit
RUN mkdir /etc/sv/nginx
ADD nginx-run /etc/sv/nginx/run
RUN chmod a+x /etc/sv/nginx/run
RUN ln -s /etc/sv/nginx /etc/service

# Add php5-fpm aemon to runit
RUN mkdir /etc/sv/php5-fpm
ADD php5-fpm-run /etc/sv/php5-fpm/run
RUN chmod a+x /etc/sv/php5-fpm/run
RUN ln -s /etc/sv/php5-fpm /etc/service

RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini

RUN rm -rf /var/lib/apt/lists/*