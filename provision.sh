# Provision the following:
#   - Logstash - server to process log input
#   - Elasticsearch - log data store
#   - Kibana - frontend; interfaces w/ Elasticsearch
#   - Filebeat - "spies" on app servers sending communiques to logstash
# NOTES: will collect logs syslogs
#   - NGINX reverse proxies to the ELK Server 
#   - FILEBEAT is installed on any server for which we want to collect logs

# ELK Reverse Proxy Diagram:
# USER --> NGINX --> [KIBANA --> ELASTICSEARCH <-- LOGSTASH] <-- FILEBEAT/AppServer

# set sources 
# --- JAVA8
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default
# --- ELASTICSEARCH
sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
# --- KIBANA
sudo echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
# --- LOGSTASH
sudo echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list

# update repos with new sources
sudo apt-get update

# download resources
sudo apt-get -y install elasticsearch kibana nginx apache2-utils logstash

# config the apps
# --- ELASTICSEARCH
sudo sed -i -e 's/# network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start
# --- KIBANA
sudo sed -i -e 's/0.0.0.0/localhost/' /opt/kibana/config/kibana.yml
sudo update-rc.d kibana defaults 96 9
sudo /etc/init.d/kibana start
# --- NGINX
sudo htpasswd -b -c /etc/nginx/htpasswd.users vagrant vagrant
sudo rm /etc/nginx/sites-enabled/default
sudo cp /vagrant/nginx_config /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled
sudo /etc/init.d/nginx restart
# --- LOGSTASH -- NEED TO FINISH!!!
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
sudo /etc/init.d/logstash start
