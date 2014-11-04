FROM aooj/collectd:latest
MAINTAINER AooJ "aooj@n13.cz"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 505A7412
RUN echo "deb http://s3.amazonaws.com/tokumx-debs $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/tokumx.list

RUN apt-get update && apt-get install -y tokumx pwgen && apt-get clean

ADD files/start.sh /opt/run/setup-mongo.sh
ADD files/collectd /etc/collectd/collect.d
ADD files/supervisor-mongo.conf /etc/supervisor/conf.d/mongodb.conf


VOLUME /data
VOLUME /var/log/tokumx

EXPOSE 27017
