curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"searchable_text",
     "type":"text_en_splitting",
     "indexed":true,
     "multiValued":true,
     "uninvertible":false
     "stored":false }
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"description_t",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"face_recognition_identities_celebname_ss",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"image_action_recognition_action_t",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"image_captioning_caption_t",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"object_detection_object_ss",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"video_action_recognition_action_ss",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema

  curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-copy-field":{
     "source":"face_recognition_identities_celebname_ss",
     "dest":[ "searchable_text" ]}
}' http://localhost:8983/solr/mediaverse/schema
