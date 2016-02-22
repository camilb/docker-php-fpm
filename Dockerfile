FROM camil/php-fpm-wheezy
MAINTAINER Camil Blanaru <camil@edka.io>

#install laravel requirements and aditional extensions
RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4  zlib1g-dev git wget vim" \
    && apt-get update && apt-get install -y $requirements \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    && docker-php-ext-install json \
    && docker-php-ext-install zip \
    && requirementsToRemove="libmcrypt-dev g++ zlib1g-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

#install gd
RUN buildRequirements="libpng12-dev libjpeg-dev libfreetype6-dev" \
    	&& apt-get update && apt-get install -y ${buildRequirements} \
    	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib \
    	&& docker-php-ext-install gd \
    	&& apt-get purge -y ${buildRequirements} \
    	&& rm -rf /var/lib/apt/lists/*

#copy install script
COPY couchbase-csdk-setup /usr/local/src/

# Install Couchbase C-library
RUN echo "deb http://packages.couchbase.com/ubuntu wheezy wheezy/main" >> /etc/apt/sources.list \
      && apt-get update \
      && perl /usr/local/src/couchbase-csdk-setup  \
      && rm -rf /var/lib/apt/lists/*

#add couchbase repository
RUN echo "deb http://packages.couchbase.com/ubuntu wheezy wheezy/main" >> /etc/apt/sources.list

#copy couchbase extension v2.1
COPY couchbase.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/

#install composer globally
RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

#replace default php-fpm config
RUN rm -v /usr/local/etc/php-fpm.conf

COPY config/php-fpm.conf /usr/local/etc/

#add custom php.ini
COPY config/php.ini /usr/local/etc/php/

#enable couchbase extension
RUN echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/couchbase.so" >> /usr/local/etc/php/php.ini

# Setup Volume
VOLUME ["/usr/share/nginx/html"]

#Set Workdir
WORKDIR /usr/share/nginx/html

#Change www-data UID
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

#Add entrypoint
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]
