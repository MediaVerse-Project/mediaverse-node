#Create DAM service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=dam-service' \
--data 'url=http://dam:8888'

#Create UI service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=ui-service' \
--data 'url=http://dashboard-ui:80'

#Create IPFS service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=ipfs-service' \
--data 'url=http://mv_ipfs_api:4040'

#Create IPR service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=ipr-service' \
--data 'url=http://ipr-service:8081'

#Create Copyright-negotiation service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=copyright-negotiation-service' \
--data 'url=http://copyright-negotiation:3003'

#Create moderation UI service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=moderation-ui-service' \
--data 'url=http://moderation-ui:80'

#Create template studio service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=template-studio-service' \
--data 'url=http://slc-template-studio:8084'

#Create fader360 service
curl -i -X POST \
--url http://kong:8001/services \
--data 'name=fader360-service' \
--data 'url=http://fader360-reverseproxy'