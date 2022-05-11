
# MediaVerse

## Introduction

[MediaVerse](https://mediaverse-project.eu/) is funded under the Horizon2020 scheme of the European Commission.
The goal of this project is to set up a decentralised network of content management nodes through which content owners and creators can easily exchange content and negotiate media rights while next generation authoring tools and innovative collaboration spaces foster the creation of personalised, immersive and accessible future media experiences.

### What’s the idea?

In the first years of this century a phenomenon called Web 2.0 began to enable virtually everyone to create and publish content without technical background. Creating websites had already been easy – then the blogosphere opened the world of text publishing, image exchange, and even video publishing became easier than ever. Everything was for free, both publishing and consuming. Since then, a few social media companies have risen to dominate the world of content creation offering tools and services to create and publish all sorts of media – largely under their control.

This is where MediaVerse comes in: MediaVerse aims to enable all sorts of content creators, from traditional publishers and freelance creators or artists to anyone who wants to share their ideas, to create and share their media, while keeping control of their intellectual property rights. MediaVerse aims to provide a set of tools to support all steps in this process:

- Co-creation tools, where multiple users can work on their projects together, supporting also immersive media like interactive 360° videos and 3D objects;
- Social analytics tools to follow the trends and connect with your existing Social Media channels both ways – re-using the media you posted there as well as posting your new creations;
- A decentralised network to share the media;
- AI-supported tools for content analysis to make it easier to find content fragments on which to build your media, including tools to spot inappropriate content to protect your audience;
- Blockchain-enabled tools to negotiate your intellectual property rights and be paid appropriately;
- Automated language translation and other tools to facilitate the creation of accessible media.

## MediaVerse Node Deployment

MediaVerse Node consists of the Docker containers depicted in the following diagram:

![MediaVerse Node service](docker-containers.png)

Each of these containers is defined in the [docker-compose](./Deployme/docker-compose.yml) file.

### Basic configuration

The deployment structure consists of a **docker-compose** file, a **mongo init script** and a config folder. The [docker-compose](./Deployme/docker-compose.yml) file, the [init-mongo.js](./Deployme/init-mongo.js) and the config folder must be placed in the root level.

1. The docker-compose file contains all the images/networks/volumes for the docker engine. It is predefined and it is common for all the nodes.
2. The mongo init script will be called by the docker-compose file to properly initialize the DB. It is predefined and it is common for all the nodes.
3. The config folder has the following structure:

```sh
config
..dam
..mongo
..right-management
..ui
```

This folder includes all the configuration of the node.

All the below *not common* variables must be set before running the docker-compose file.

#### **a) Mongo:** `./config/mongo/.env`

```sh
MONGO_DB_NAME=root_db # It is the name of the DB
MONGO_ROOT_USERNAME=<not common> # It is the Admin username of the DB
MONGO_ROOT_PASSWORD=<not common> # It is the password of the Admin user
```

For example:

```sh
MONGO_DB_NAME=root_db
MONGO_ROOT_USERNAME=root
MONGO_ROOT_PASSWORD=b51d1c*5287&11ec
```

#### **b) DAM:** `./config/dam/.env`

Set mongo db parameters: 

```sh
# Mongo DB parameters
# The same values as in a)
MONGO_DB_NAME=<not commom>
MONGO_ROOT_USERNAME=<not common>
MONGO_ROOT_PASSWORD=<not common>
```

Set asset storage:

```sh
FILE_HOST_ENV=<not common>
```

Currently supported **local** and **S3**: **local** means that the storage will be based on the running machine, **S3** means that the files will be stored on the Amazon.

For local storage add:

```sh
FILE_HOST_ENV=local
```

For external storage, an active S3 storage must be created. Please check [S3 documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html).
The following parameters must be included in the `.env`:

```sh
FILE_HOST_ENV=S3

S3_BUCKET_NAME=<not common>
AWS_ACCESS_KEY_ID=<not common>
AWS_SECRET_ACCESS_KEY=<not common>
AWS_REGION=<not common>
```

The domain or IP of the DAM has to be configured. This value is used to generate proxy format links and deep links.

```sh
DAM_DOMAIN=<not common> # It is the DOMAIN of the node
```

For example:

```sh
DAM_DOMAIN=https://xxx.xxx.xxx.xxx:5000
```

with `xxx.xxx.xxx.xxx` being the IP of the server in which the service is deployed, and `5000` being the port in which DAM's API is exposed.

A vague name which specifies the name of the node should be specified.

```sh
DAM_NAME=<not commom> 
# For example:
DAM_NAME=atc-vm.gr
```

Finally, a twitter dev account must be set. Please refer to [Twitter's documentation](https://developer.twitter.com/en/docs/authentication/overview)

```sh
TWITTER_OAUTH_CONSUMER_KEY=<not common - define the dev twitter key>
TWITTER_OAUTH_CONSUMER_SECRET=<not common - define the dev twitter secret>
```

The followong parameters can be left untouched:

```sh
SOLR_URL=http://solr:8983/solr # the same for all nodes. 
IPR_URL=http://ipr-service:8081 # the same for all nodes
TRANSCODER_URL=http://transcoder:5000 # the same for all nodes

# it is the URL of NDD service
NDD_URL=<not common> # for V1 it will be the same for all nodes 
# For example:
NDD_URL=https://mever.iti.gr/ndd/api/v3

# the URL of the media annotation service
GRPC_URL=<not common>  # for V1 it will be the same for all nodes, 
# For example:
GRPC_URL=160.40.53.61:37526

SERVER_PORT=8888 # the same for all nodes
```

#### **c) Right-Management components:**

First, the *cicero-template-library* must be cloned from gitlab:

```sh
git clone https://gitlab.com/mediaverse/wp4/smart-legal-contracts/mv-cicero-template-library.git
```

##### Parameters that shall be configured

Edit *mv-slc-engine* and *cicero-server* services in the [Deployme/docker-compose.yml](./Deployme/docker-compose.yml):

```sh
mv-slc-engine:   
  volumes:
  - "path/to/mv-cicero-template-library:/mv-cicero-template-library"

cicero-server:   
  volumes:
  - "path/to/mv-cicero-template-library:/mv-cicero-template-library"
```

*path/to/mv-cicero-template-library* shall be the path where the *mv-cicero-template-library* was cloned.

Edit `Deployme/config/right-management/ipr-service/application.yml` to add *bearer token* of the IPR Service (to make requests to DAM):

```sh
server:
  bearer-token: XXXX  
```

For v1, the following *bearer token* can be used:

```sh
server:
  bearer-token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJub2RlbmFtZSI6ImF0Yy12bS5nciIsInJvdXRpbmdJZCI6IjYyNDJhOGUyZTk0NWVlNzJkYTIwNGVmOUBhdGMtdm0uZ3IiLCJpZCI6IjYyNDJhOGUyZTk0NWVlNzJkYTIwNGVmOSIsImVtYWlsIjoiaXByLXNlcnZpY2VAbWVkaWF2ZXJzZS5hdGMuZ3IiLCJ1c2VybmFtZSI6Imlwci1zZXJ2aWNlQG1lZGlhdmVyc2UuYXRjLmdyIn0.CrAdaiqXYnqnS_khc5bKhMQmT4NXNhgj3Rl0WYXY9FY
```

Edit `Deployme/config/right-management/mv-bcsp/.env` to include private key for MV ethereum network

```sh
DEFAULT_MV_NODE_PRIVATE_KEY=XXXX
```

For that parameter, one of the private keys that are generated by the **mv-eth** container that can be retrieved by looking at the container logs. As for now the keys are fixed and generated from the same seed 'mediaverse':

```sh
DEFAULT_MV_NODE_PRIVATE_KEY=XXXX
```

##### Parameters that can be left untouched

`Deployme/config/right-management/ipr-service/application.yml`

```sh
server:
  port: 8081  #port on which ipr-service is listening
  error:
    include-message: always #enable error detailed description
mv-services-basepaths:
  mv-blockchain-service-provider: http://mv-bcsp:8082/ipr/bc  #endpoint of the BCSP
  mv-slc-engine: http://mv-slc-engine:8083  #endpoint of the MV SLC Engine
  mediaverse-node-backend: http://mv-dam-api:8888  #endpoint of the MV Node Backend
```

`Deployme/config/right-management/mv-slc-engine/application.yml`

```sh
server:
  port: 8083  #port on which mv-slc-engine is listening
  error:
    include-message: always #enable error detailed description
mv-services-basepaths:
  cicero-server: http://cicero-server:6001  #endpoint of the cicero-server
slc-templates:
  library-dir: /mv-cicero-template-library  #path of the SLC templates library (inside the container)
```

`Deployme/config/right-management/cicero-server/.env`

```sh
CICERO_PORT=6001  #port on which cicero-server is listening
CICERO_DIR=/mv-cicero-template-library  #path of the SLC templates library (inside the container)
```

`Deployme/config/right-management/mv-bcsp/config/config.json` shall be empty during first run

`Deployme/config/right-management/mv-bcsp/.env`

```sh
NODE_ENV="mv-eth" #name of the docker service container of the local blockchain deployment
```

`Deployme/config/right-management/mv-bcspeh/.env`

```sh
NODE_ENV=mv-eth #name of the docker service container of the local blockchain deployment
IPR_SERVICE_ENDPOINT=http://ipr-service:8081/ #endpoint of the IPR Service
UPDATE_API_ENDPOINT=event/update #path of the event update API of the IPR Service
```

#### **d) UI** `./config/ui/.env`

The following URLs should be defined:

```sh
# It is the DOMAIN of the node. It is the same domain as b)
REACT_APP_API_URL=http://xxx.xxx.xxx.xxx:5000 

# It is the DOMAIN of the node. It is the same domain as b)
REACT_APP_IPR_URL=http://xxx.xxx.xxx.xxx:5000 

REACT_APP_METADATA_URL=http://xxx.xxx.xxx.xxx:3002
REACT_APP_IPFS_URL=http://xxx.xxx.xxx.xxx:5050/api
REACT_APP_TRANSCODING_URL=http://xxx.xxx.xxx.xxx:5500
REACT_APP_THUMBNAIL_URL=http://xxx.xxx.xxx.xxx:5501
REACT_APP_LICENSES_URL=http://xxx.xxx.xxx.xxx:3003

# It is the domain of the node plus the port of ipfs api (4040)
REACT_APP_FEDSE_URL=http://xxx.xxx.xxx.xxx:4040

```

All of these services point to the same IP in which the services are deployed (`xxx.xxx.xxx.xxx`), with a different port according to the service.

A firebase account must be set, please refer to [Firebase documentation](https://firebase.google.com/docs/auth/web/twitter-login):

```sh
REACT_APP_FIREBASE_AUTH_DOMAIN=<not commom>
REACT_APP_FIREBASE_API_KEY=<not common>
```

#### **e) IPFS API** 

IPFS bootstrap node:

```sh
IPFS_BOOTSTRAP_ADDR= /ip4/77.231.202.172/tcp/4001/p2p/12D3KooWPr8KvRorAu2yPWmKg6CwbjayWpZn49vRuPq59t6gJ7Ds
```

That parameter helps IPFS to discover the rest of the nodes in the neowork. For v1, `/ip4/77.231.202.172/tcp/4001/p2p/12D3KooWPr8KvRorAu2yPWmKg6CwbjayWpZn49vRuPq59t6gJ7Ds` will be used as bootstrap node for network discivery. 

Local DAM address (It is the same domain as b):

```sh
DAM_ADDR=http://xxx.xxx.xxx.xxx:5000
```

The following parameters canbe left untouched:

```sh
IPFS_NODE_IP=ipfs_host # Container name of the IPFS Host service. Default: ipfs_host
IPFS_NODE_PORT=5001 # Port of the IPFS Host service. Default: 5001
IPFS_NODE_TIMEOUT=10
FSEARCH_RESULT_TIMEOUT=30
```

### How to run it with Docker

Run the application, from the root level order:

```sh
docker-compose pull # pull the images
docker-compose up -d # run the docker-compose
```

### How to update the Solr schema

After successfully deployed the compose, update the SOLR schema by executing the [solr_schema.sh](./Deployme/solr_schema.sh)

```sh
chmod a+x solr_schema.sh
dos2unix solr_schema.sh
./solr_schema.sh
```

If the execution of script fails try to execute the included curl commands manually.
