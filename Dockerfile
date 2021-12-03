FROM ubuntu:bionic

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get install -y curl
RUN apt-get install -y build-essential libssl-dev
RUN apt-get install -y python
RUN apt-get install -y git

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.12.0

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN mkdir /usr/app
RUN mkdir /usr/app/log

WORKDIR /usr/app

# log dir
VOLUME /usr/app/log

# Bundle app source
COPY . /usr/app
# Install app dependencies
RUN npm install
RUN npm remove -g bower
RUN npm remove -g gulp
RUN npm remove gulp
RUN npm install -g bower
RUN npm install -g gulp@3.9.0
RUN npm install gulp@3.9.0

WORKDIR /srv
VOLUME /srv

ENV LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["gulp"]
