!/bin/env bash

sudo su -
apt install default-jdk
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.2.deb
dpkg -i elasticsearch-6.4.2.deb
apt-get install -f
echo "
#this feature will provide security using x-pack to elasticsearch.

xpack.security.enabled: true

http.cors.enabled: true

http.cors.allow-origin: '*'

http.cors.allow-headers: Authorization,X-Requested-With,Content-Length,Content-Type

cluster.name: paris

node.name: [any name you want to assign]

#mark it true only for master nodes

node.master: false

#mark it true for master nodes as a master node can run both as data node and ingest node.

node.data: true

node.ingest: true

discovery.zen.hosts_provider: ec2

discovery.zen.ping.unicast.hosts: [private ip of all the nodes in cluster]

#Elasticsearch service will bind itself with the private ip of node, curl <private ip of master node>:9200 -u <username> <password>
network.host: [private ip of the node]" >> /etc/elasticsearch/elasticsearch.yml
