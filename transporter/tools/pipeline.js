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