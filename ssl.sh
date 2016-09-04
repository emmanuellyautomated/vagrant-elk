#!/bin/bash

source /home/vagrant/.profile

key='subjectAltName = IP: ';
echo "|--> HOST_IP: $HOST_IP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
sudo sed -i -e "s/ v3_ca ]/ v3_ca ]\n$key$HOST_IP/" /etc/ssl/openssl.cnf

cd /etc/pki/tls
sudo openssl req -config /etc/ssl/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
