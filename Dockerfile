FROM debian:9

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

### Instalacion de Weathermap

# Instalacion de paquetes
RUN apt-get -y install mrtg openssh-client nginx supervisor
ADD ./assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Scripts Install
RUN mkdir /scripts
COPY ./assets/scripts /scripts

# MRTG Config
RUN mkdir /images
COPY ./assets/images /images
RUN mkdir /template
COPY ./assets/template /template

# SSh config
ADD ./assets/config /root/.ssh/
COPY ./assets/bashrc /root/.bashrc

#NginX config
RUN sed -i 's|/var/www/html|/data/html|g' /etc/nginx/sites-available/default
RUN sed -i 's|/var/log/nginx|/data/logs|g' /etc/nginx/nginx.conf

### Limpiamos
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/*
RUN rm -rf /var/lib/apt/lists/*

# Creacion and Startup Script
ADD ./assets/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
