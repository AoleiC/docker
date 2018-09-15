function transform(doc) {
   doc.data["mongo_id"] = doc.data._id['$oid'];
   doc.data["id"] = doc.data["_id"]; 
   return doc;
}