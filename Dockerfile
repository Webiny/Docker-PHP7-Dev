FROM webiny/php7:1.0.0

RUN apt-get install sudo && apt-get install vim -y

RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
         && apt-get update \
         && apt-get install -y git lsof \
         && apt-get clean all

# Produces errors when using git with https - known issue.
RUN sudo apt-get remove libgnutls-deb0-28 -y

RUN mkdir -p /.cache/yarn /.cache/composer && chmod 777 -R /.cache \
   && mkdir /.yarn && chmod 777 -R /.yarn \
   && touch /.yarnrc && chmod 777 /.yarnrc \
   && mkdir /.npm && chmod 777 -R /.npm

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN cd /tmp \
    && curl -LO https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

# Install git, node and yarn
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
    && apt -y install build-essential \
    && apt -y install nodejs \
    && npm i -g npm

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update && apt install yarn

# Clean file
RUN apt-get autoclean

RUN echo 'alias ll="ls -alh"' >> ~/.bashrc
RUN ln -sf /home/.webiny/cli/node_modules/webiny-cli/run.js /usr/local/bin/webiny-cli

ENV WEBINY_ENVIRONMENT="docker"