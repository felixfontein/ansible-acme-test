FROM golang:1.10-stretch
# Install software
RUN apt-get update
RUN apt-get install -y bind9 python3 python3-pip
ADD requirements.txt /root/
RUN pip3 install -r /root/requirements.txt
# Setup bind9
ADD bind.conf /etc/bind/named.conf
RUN mkdir /etc/bind/zones
# Install pebble
ARG PEBBLE_CHECKOUT="c0cc64314be427c6d39679e95a7794c89a293912"
ENV GOPATH=/go
RUN go get -u github.com/letsencrypt/pebble/... && \
    cd /go/src/github.com/letsencrypt/pebble && \
    git checkout ${PEBBLE_CHECKOUT} && \
    go install ./...
ADD pebble-config.json /go/src/github.com/letsencrypt/pebble/test/config/pebble-config.json
# Setup controller.py and run.sh
ADD run.sh controller.py /root/
EXPOSE 5000 14000
CMD [ "/bin/sh", "-c", "/root/run.sh" ]
