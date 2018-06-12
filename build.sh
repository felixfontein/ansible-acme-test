#!/bin/bash
DOMAINS="example.com example.org t1.example.com t2.example.com t3.example.com t1.example.org t2.example.org t3.example.org"

build_nginx_config() {
    echo "server {" > nginx-pebble
    echo "    listen *:80 default_server;" >> nginx-pebble
    echo "    location / {" >> nginx-pebble
    echo "        return 404 'this site does not exist';" >> nginx-pebble
    echo "    }" >> nginx-pebble
    echo "}" >> nginx-pebble
    for DOMAIN in ${DOMAINS}; do
        echo "server {" >> nginx-pebble
        echo "    listen *:80;" >> nginx-pebble
        echo "    server_name ${DOMAIN};" >> nginx-pebble
        echo "    location /.well-known/acme-challenge/ {" >> nginx-pebble
        echo "        alias /lechallenges/${DOMAIN}/;" >> nginx-pebble
        echo "    }" >> nginx-pebble
        echo "    location / {" >> nginx-pebble
        echo "        return 200 'this site is empty';" >> nginx-pebble
        echo "    }" >> nginx-pebble
        echo "}" >> nginx-pebble
    done
}

build_pebble() {
    docker pull golang:1.10-stretch

    rm -rf build
    trap "{ rm -rf build ; }" EXIT

    mkdir build
    cp nginx-pebble pebble-config.json bind.conf example.org example.com build/
    # Start script
    echo "#!/bin/sh" > "build/run.sh"
    echo "echo nameserver 127.0.0.1 > /etc/resolv.conf" >> "build/run.sh"
    echo "service bind9 start" >> "build/run.sh"
    echo "service nginx start" >> "build/run.sh"
    echo "cd /root/go/src/github.com/letsencrypt/pebble" >> "build/run.sh"
    echo "/root/go/bin/pebble -config /root/go/src/github.com/letsencrypt/pebble/test/config/pebble-config.json" >> "build/run.sh"
    # Dockerfile
    echo "FROM golang:1.10-stretch" > build/Dockerfile
    # Install software
    echo "RUN apt-get update" >> build/Dockerfile
    echo "RUN apt-get install -y nginx bind9 $1" >> build/Dockerfile
    # Setup nginx
    echo "ADD nginx-pebble /etc/nginx/sites-available/pebble" >> build/Dockerfile
    DOMAIN_FOLDERS=""
    for DOMAIN in ${DOMAINS}; do
        DOMAIN_FOLDERS="${DOMAIN_FOLDERS} /lechallenges/${DOMAIN}"
    done
    echo "RUN mkdir /lechallenges ${DOMAIN_FOLDERS} && rm /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/pebble /etc/nginx/sites-enabled/pebble" >> build/Dockerfile
    echo "RUN service nginx restart" >> build/Dockerfile
    # Setup bind9
    echo "ADD bind.conf /etc/bind/named.conf" >> build/Dockerfile
    echo "RUN mkdir /etc/bind/zones" >> build/Dockerfile
    echo "ADD example.com example.org /etc/bind/zones/" >> build/Dockerfile
    echo "RUN service bind9 restart" >> build/Dockerfile
    # Install pebble
    echo "ENV GOPATH=/root/go" >> build/Dockerfile
    echo "RUN go get -u github.com/letsencrypt/pebble/..." >> build/Dockerfile
    echo "RUN cd /root/go/src/github.com/letsencrypt/pebble ; go install ./..." >> build/Dockerfile
    echo "ADD pebble-config.json /root/go/src/github.com/letsencrypt/pebble/test/config/pebble-config.json" >> build/Dockerfile
    # Setup run.sh as main process
    echo "ADD run.sh /run.sh" >> build/Dockerfile
    echo "RUN chmod a+x /run.sh" >> build/Dockerfile
    echo "CMD [ \"/bin/sh\", \"-c\", \"/run.sh\" ]" >> build/Dockerfile
    echo "EXPOSE 14000" >> build/Dockerfile
    docker build --force-rm -t pebble:$2 build/

    rm -rf build
}

build_nginx_config
build_pebble python2.7 2
build_pebble python3 3
