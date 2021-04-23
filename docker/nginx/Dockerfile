FROM nginx:1.11

ENV SYMFONY_ALLOW_APPDEV=0

#COPY conf/symfony.conf /etc/nginx/conf.d/default.conf

COPY conf/symfony.conf /etc/nginx/conf.d/default.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/sites_default.conf /etc/nginx/sites/default.conf

WORKDIR /var/www/sites/playme/playme
CMD ["nginx"]
EXPOSE 80
