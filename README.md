# Installing elasticsearch cluster usingterraform
Installing elasticsearch cluster on AWS EC2 instance using terraform.

# Once the elasticsearch is installed we need to make some changes in yaml file of elasticsearch.
 <p> Path of elasticsearch.yml </p>
 
cd  /etc/elasticsearch/elasticsearch.yml

http.port:  9200 (need to uncomment)

# Added the below parameters, in order to setup authentication on ElasticSearch. 
###############################################################################################

xpack.security.enabled: true

http.cors.enabled: true

http.cors.allow-origin: '*'

http.cors.allow-headers: Authorization,X-Requested-With,Content-Length,Content-Type

#################################################################################################

# Add the below stanza for setting elasticsearch cluster in each node.

cluster.name: (name you want ot assign to cluster)

node.name: (master,data,ingest)

#make it true only for master noes only.

node.master: false

#make it true for data node.

#optional:Master node(a master node can work both as data node or ingest node)

node.data: false

#Make it true for ingest node.

node.ingest: false

discovery.zen.hosts_provider: ec2

discovery.zen.ping.unicast.hosts: [mention the private ip of all the nodes,master,data,ingestion]

network.host: [mention private ip of the node]
###############################################################################################################
# In order to make ec2 discoverable installed a plugin.

cd /usr/share/elasticsearch/bin

./elasticsearch-plugin install discovery-ec2
#################################################################################################################
 #Once its installed
 
For the security purpose run the following script to setup password for elasticsearch:

./ elasticsearch-setup-passwords

There is 2 way you can setup password using interactive mode or auto mode.
##################################################################################################################
# For testing purpose.
Curl (private ip of master node) :9200  -u (username) (password)

We have configured private ip of the node for curl, not the local host. 

# Important point:
Please configure the jvm option since I was using ec2 instance with 1 gb ram xms and xmx setting set to 512mb.
Which causing lot of performance issue when I was starting elasticsearch service, recommend not to bind it with daemon service of instance if your RAM is around 1 gb.

