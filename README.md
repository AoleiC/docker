# elasticsearch
主要解决国内拉取官方镜像太慢超时的问题，版本与阿里云产品使用的版本一致。https://hub.docker.com/r/aoleic

* elasticsearch-5.5.3 单纯的5.5.3版本。
* elasticsearch-5.5.3-ik 包含中文ik分词插件的5.5.3版本。
* kibana-5.5.3 单纯的5.5.3版本，账号密码默认为 elastic \ changeme

# Transporter介绍
GitHub: https://github.com/compose/transporter

transporter 是使用golang语言开发的一款简单而又强大的数据迁移工具。它通过一种的agnostic message format数据形式轻松的将不同数据来源不同格式的数据进行转换。 transporter和mongo-connector都是监听oplog的变化来实现数据的实时同步。

transporter 可以在不同数据库之间进行数据转换迁移，同时也可以将text文件迁移至其他数据库。transporter连接不同数据源的媒介称为Adaptor. Adaptor可以配置为读数据的Source端也可以配置为作为写目标的Sink端。典型的Transporter包含一个Source和一个Sink，通过数据管道pipeline进行转换传输。transporter包含一系列本地或者JavaScript函数形式的转换器（Transformers），通过转换器可以将源数据格式进行过滤、转换以便正确的写入Sink目标数据源。

### 核心文件：
* transporter 

golang编译的二进制文件，下载来源：https://github.com/compose/transporter/releases 的 transporter-0.5.2-linux-amd64

* pipeline.js

使用transporter init mongodb elasticsearch 命令初始化生成的文件，用于管道配置 

```
var source = mongodb({
  "uri": "${MONGODB_URI}",
  "timeout": "30s",
  // "tail": false,
  //"ssl": true
  // "cacerts": ["/path/to/cert.pem"],
  // "wc": 1,
  //"fsync": true,
  //"bulk": true,
  //"collection_filters": "{\"line_id\":{\"$gt\":0}}",
  // "read_preference": "Primary"
})

var sink = elasticsearch({
  "uri": "${ELASTICSEARCH_URI}",
  "timeout": "10s" // defaults to 30s
  // "aws_access_key": "ABCDEF", // used for signing requests to AWS Elasticsearch service
  // "aws_access_secret": "ABCDEF" // used for signing requests to AWS Elasticsearch service
  // "parent_id": "elastic_parent" // defaults to "elastic_parent" parent identifier for Elasticsearch
})

t.Source("source", source, "/^${ES_TYPE}$/").Transform(goja({"filename":"./dataRebuild.js"})).Transform(pick({"fields": ["_id","id","mongo_id","title"]})).Save("sink", sink, "/^${ES_TYPE}$/")
//source的MongoDB collection 名要和 elasticsearch索引的type名称一样
//goja重新处理数据
//pick选择要传输的字段
// /^${ES_TYPE}$/ 为正则精确匹配，如果只填入${ES_TYPE}，会做模糊匹配
```
* dataRebuild.js
 
手动添加的文件，用于做数据重组或者格式化

```
function transform(doc) {
   doc.data["mongo_id"] = doc.data._id['$oid'];
   doc.data["_id"] = doc.data["_id"]; 
   doc.data["id"] = doc.data["_id"]; 
   return doc;
}

```
* startup.sh
 
手动创建的传输执行脚本，用于一键初始化导入或容器启动后自动执行

* docker-compose

配置相应的 数据库Host、账号、密码、库名、集合，账号密码没有则留空

```
transporter:
  image: registry.cn-beijing.aliyuncs.com/yoc/rch-es-transport-master
  hostname: rchestransporter
  environment:
    MG_HOST: 'localhost:27017'
    MG_USER_NAME:
    MG_USER_PWD:
    ES_HOST: 'localhost:9200'
    ES_USER_NAME: elastic
    ES_USER_PWD: changeme
    INDEX_NAME: news
    TYPE_NAME: hot
```








