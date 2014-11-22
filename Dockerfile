FROM ubuntu:14.04
MAINTAINER hgk617@naver.com

# install essential packages
RUN apt-get -qq -y install curl build-essential libssl-dev unzip mysql-client

RUN curl -L http://nodejs.org/dist/v0.10.30/node-v0.10.30-linux-x64.tar.gz -o /node

RUN tar xf node && rm -rf node && \
    bash -c "ln -s /node-v0.10.30-linux-x64/bin/{node,npm} /usr/local/bin/"

# download ghost
RUN curl -L https://ghost.org/zip/ghost-0.5.5.zip -o /ghost.zip

# install ghost
RUN unzip -uo ghost.zip -d ghost && \
    rm -f ghost.zip

RUN cd ghost && \
    npm install --porduction

ADD run.sh /run.sh

RUN chmod +x /*.sh

WORKDIR /ghost

CMD ["bash", "/run.sh"]

EXPOSE 2368
