#Create DAM route
curl -i -X POST \
  --url http://kong:8001/services/dam-service/routes \
  --data 'name=dam-route' \
  --data 'paths[]=/dam'

#Create UI route
curl -i -X POST \
  --url http://kong:8001/services/ui-service/routes \
  --data 'name=ui-route' \
  --data 'paths[]=/'

#Create IPFS route
curl -i -X POST \
  --url http://kong:8001/services/ipfs-service/routes \
  --data 'name=ipfs-route' \
  --data 'paths[]=/ipfs'

#Create IPR route
curl -i -X POST \
  --url http://kong:8001/services/ipr-service/routes \
  --data 'name=ipr-route' \
  --data 'paths[]=/ipr'

#Create Copyright-negotiation route
curl -i -X POST \
  --url http://kong:8001/services/copyright-negotiation-service/routes \
  --data 'name=copyright-negotiation-route' \
  --data 'paths[]=/copyright'

#Create moderation-ui route
curl -i -X POST \
  --url http://kong:8001/services/moderation-ui-service/routes \
  --data 'name=moderation-ui-route' \
  --data 'paths[]=/moderation-ui'