#! /bin/bash -ex

# https://www.elastic.co/guide/en/elasticsearch/reference/8.8/deb.html

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch \
	| sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
	| sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update
sudo apt install -y apt-transport-https java-common default-jre-headless
sudo apt install -y elasticsearch kibana

sudo systemctl daemon-reload

sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

sudo systemctl enable kibana.service
sudo systemctl start kibana.service

#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-geoip
#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-user-agent

# logstash
#sudo apt install -y openjdk-8-jre-headless
#sudo apt install -y logstash
# edit file /etc/logstash/startup.options
