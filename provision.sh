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
sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y -qq install oracle-java8-installer > /dev/null 2>&1
sudo apt-get -y -qq install oracle-java8-set-default > /dev/null 2>&1
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
# --- ELEASTICSEARCH --> index filebeat template
sudo curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/
sudo curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json
# --- KIBANA
sudo sed -i -e 's/0.0.0.0/localhost/' /opt/kibana/config/kibana.yml
sudo update-rc.d kibana defaults 96 9
sudo /etc/init.d/kibana start
cd /home/vagrant/
# --- KIBANA --> dashboards
sudo curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
sudo apt-get -y install unzip
sudo unzip beats-dashboards-*.zip
cd beats-dashboards-*
sudo ./load.sh
# --- NGINX
sudo htpasswd -b -c /etc/nginx/htpasswd.users vagrant vagrant
sudo rm /etc/nginx/sites-enabled/default
sudo cp /vagrant/confs/nginx_config /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled
sudo /etc/init.d/nginx restart
# --- LOGSTASH
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
sudo /vagrant/ssl.sh  # create an SSL certificate in appropriate place
sudo cp /vagrant/confs/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf
sudo cp /vagrant/confs/10-syslog-filter.conf /etc/logstash/conf.d/10-syslog-filter.conf
sudo cp /vagrant/confs/30-elasticsearch-output.conf /etc/logstash/conf.d/30-elasticsearch-output.conf
sudo update-rc.d logstash defaults 96 9
sudo /etc/init.d/logstash start
