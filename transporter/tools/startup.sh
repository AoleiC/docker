#!/usr/bin/env bash

# 连接配置账号密码【等号后不能加空格，使用127.0.0.1速度会快些】
#MG_HOST=127.0.0.1:27017
#MG_USER_NAME=root
#MG_USER_PWD=123456 
#
#ES_HOST=127.0.0.1:9200
#ES_USER_NAME=elastic
#ES_USER_PWD=changeme 
#
#INDEX_NAME=news
#TYPE_NAME=host

# mongo 的连接串（判断是否使用密码）

if [ -n "$MG_USER_NAME"];then
	export MONGODB_URI=mongodb://$MG_HOST/$INDEX_NAME
else 
	export MONGODB_URI=mongodb://$MG_USER_NAME:$MG_USER_PWD@$MG_HOST/$INDEX_NAME?authSource=admin
fi

# es 的连接串
if [ -n "$ES_USER_NAME"];then
	export ELASTICSEARCH_URI=http://$ES_HOST/$INDEX_NAME
else 
	export ELASTICSEARCH_URI=http://$ES_USER_NAME:$ES_USER_PWD@$ES_HOST/$INDEX_NAME
fi

# 导入es的type，需要与mongo的一致
export ES_TYPE=$TYPE_NAME

printf " \n -- ENV SETTING OK ! \n\n"

# 删除原有的index
curl -u $ES_USER_NAME:$ES_USER_PWD -X DELETE "$ES_HOST/$INDEX_NAME"
printf " \n -- DELETE $INDEX_NAME OK ! \n\n"

# 添加新的index
curl -u $ES_USER_NAME:$ES_USER_PWD -X PUT "$ES_HOST/$INDEX_NAME" -H "Content-Type: application/json" -d'
{
    "mappings": {
        "$TYPE_NAME": {
            "properties": {
                "id": {
                    "type": "keyword"
                },
                "mongo_id": {
                    "type": "string"
                },
                "title": {
                    "type": "string",
                    "analyzer": "ik_max_word",
                    "search_analyzer": "ik_max_word"
                }
            }
        }
    }
}'
printf " \n -- CREATE $INDEX_NAME OK ! \n\n"

# 执行导入操作
transporter run pipeline.js

printf " -- TRANSPORT OK ! \n\n"

# 调试使用，不退出docker
# env
# tail -f /dev/null