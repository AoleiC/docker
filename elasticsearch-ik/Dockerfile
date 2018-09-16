FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.3

MAINTAINER aolei <ca_lei@live.cn>

RUN ./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.5.3/elasticsearch-analysis-ik-5.5.3.zip

RUN chown 777 -R /usr/share/elasticsearch/data