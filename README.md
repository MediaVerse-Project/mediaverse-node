
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
..kong
..mongo
..right-management
..ui
..ipfs_api
..ipfs_host
..solr
..postfix
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
MONGO_CONNECTION_URL=<not commom>
MONGO_DB_NAME=<not commom>
MONGO_ROOT_USERNAME=<not common>
MONGO_ROOT_PASSWORD=<not common>
```

*MONGO_CONNECTION_URL* parameter has the following structure:

*mongodb://MONGO_ROOT_USERNAME:MONGO_ROOT_PASSWORD@mongo:27017/MONGO_DB_NAME?authSource=admin&readPreference=primary&directConnection=true&ssl=false*

where *MONGO_ROOT_USERNAME*, *MONGO_ROOT_PASSWORD*, *MONGO_DB_NAME* should be replaced with their actual values.

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
DAM_DOMAIN=<not common> # It is the DOMAIN of the node + the DAM path as served by KONG GW
```

For example:

```sh
DAM_DOMAIN=http://{DOMAIN_NAME}/dam
```

or 

```sh
DAM_DOMAIN=https://my.domain.com:5000
```

with `xxx.xxx.xxx.xxx` being the IP of the server in which the service is deployed, and `5000` being the port in which DAM's API is exposed.

A vague name which specifies the name of the node should be specified.

```sh
DAM_NAME=<not commom> 
# For example:
DAM_NAME=atc-vm.gr
```

Maximum file size limit can also be set:
```sh
SPRING_SERVLET_MULTIPART_MAX-FILE-SIZE=25MB # meaning total file size cannot exceed 25MB.
SPRING_SERVLET_MULTIPART_MAX-REQUEST-SIZE=25MB #meaning total request size for a multipart/form-data cannot exceed 128KB.
## If not set 25MB will be the default
```

```sh
DAM_NAME=<not commom> 
# For example:
DAM_NAME=atc-vm.gr
```

For interacting with twitter an API Key and Secret must be generated following the below steps:
Sign up for a developer account:

1. Log-in to Twitter and verify your email address. (Note that the email and phone number verification from your Twitter account may be needed to apply for a developer account, review on the Twitter help center: email address confirmation or add phone number.)
2. Click sign up at developer.twitter.com to enter your developer account name, location and use case details
3. Review and accept the developer agreement and submit
4. Check your email to verify your developer account. Look for an email from developer-accounts@twitter.com that has the subject line: "Verify your Twitter Developer Account" Note: the developer-accounts@twitter.com email is not available for inbound requests.
5. You should now have access to the Developer Portal to create a new App and Project with Essential access, or will need to continue your application with Elevated access
6. If you apply for Elevated access (or Academic Research access) please continue to check your verified email for information about your application.
To check if you have a developer account go to the developer portal dashboard to review your account status and setup.

To acquire an API Key and Secret:
Create a Twitter App: https://developer.twitter.com/en/docs/apps within the developer portal.
 
When you create your Twitter App, you will be presented with your API Key and Secret, along with a Bearer Token. Please note that these credentials are displayed only once, so make sure to save them in your password manager or somewhere secure.

Please refer to [Twitter's documentation](https://developer.twitter.com/en/docs/authentication/overview) for more details.

```sh
TWITTER_OAUTH_CONSUMER_KEY=<not common - define the dev twitter key>
TWITTER_OAUTH_CONSUMER_SECRET=<not common - define the dev twitter secret>
```

For interacting with YouTube Data API v3 you need to create or use an existing Google account used for the project.

Follow the steps below to complete the Google project creation and configuration.

Sign in to Google account:

1. From the Google's account console (https://console.cloud.google.com/) you should create a new project (provide project name and location).
2. From the menu on the left select APIs & services -> Enabled APIs & services.
3. From the button on the top click Enable APIS AND SERVICES and search for YouTube Data API v3. Click the card and 
   select ENABLE, to make the  YouTube DATA API active for the project. After the YouTube API is enabled you will land 
   to the APIs configuration page.
4. From there, navigate to the Credentials from the menu on the left.
5. From the top select create Credentials and select the API Key type of credential. This will create and API key for our YouTube enabled API which we will set to GOOGLE_API_KEY key of the .env file of the DAM. This API key will be used to perform actions to the PUBLIC available data of YouTube using the DAM integration.
```sh  
GOOGLE_API_KEY  =<not common - define the dev Google API key>  
```
7. To enable DAM YouTube integration to post a video on behalf of a logged-in user to his/her YouTube channel we should 
   also create a new Credential of type OAuth client ID. This type of credential requires to configure an 
   oauth consent screen, so we will proceed with this configuration first.
8. We select from the menu on the left OAuth consent screen and follow the setup steps. We choose an "External" user 
   type and proceed with the required fields (App name, User support email and Developer contact information email.)
   configuration of the form.
9. In the next step to set up the SCOPES, we enable the scope from YouTube API v3 -> .../auth/youtube.upload
   (Manage your YouTube videos)
10. Add a test user email to the next step using the ADD USERS button and save the configuration on the last step 
    with the summary of the OAuth consent screen setup.
11. Having the OAuth consent screen configured we can proceed with the creation of the OAuth client id credential.
12. From the create credentials button on the top select the OAuth client id credential creation, and select 
    the "web application" type, give a web client name and a newly oauth client id credential is created.
13. After this process we will be provided with a client ID and a client Secret which will set to the DAM's .env file 
    to the GOOGLE_OAUTH_CLIENT_ID and GOOGLE_OAUTH_CLIENT_SECRET keys respectively.
```sh  
GOOGLE_OAUTH_CLIENT_ID =<not common - define the dev google key>  
GOOGLE_OAUTH_CLIENT_SECRET =<not common - define the dev google secret>  
```
With these keys we can make requests from the DAM to the YouTube DATA API on behalf of a logged-in user to Google 
(only for the request that cover the requested scopes - in our case only to upload videos to YouTube).

```sh
MAIL_USERNAME=mail_root@DOMAIN_EMAIL_NAME # a generic user for connecting to smtp, the DOMAIN_EMAIL_NAME must be the same as the one that will be set for postfix service
```

The following parameters can be left untouched:

```sh
SOLR_URL=http://solr:8983/solr # the same for all nodes. 
IPR_URL=http://ipr-service:8081 # the same for all nodes
IPFS_URL=http://ipfs_host:5001/api/v0/ # the same for all nodes
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

MAIL_PASSWORD=mail_password # a generic password
MAIL_HOST=postfix # the name of the postfix service
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

URLS FORMAT = {DOMAIN_NAME}/{COMPONENT_PATH}

```sh
# It is the DOMAIN of the node + /dam
REACT_APP_API_URL=http://{DOMAIN_NAME}/{dam}
# It is the DOMAIN of the node + /copyright 
REACT_APP_LICENSES_URL=http://{DOMAIN_NAME}/{copyright}
# It is the DOMAIN of the node + /ipr
REACT_APP_IPR_URL=http://{DOMAIN_NAME}/{ipr}
# It is the DOMAIN of the node + /ipfs
REACT_APP_FEDSE_URL=http://{DOMAIN_NAME}/{ipfs}

```

All of these services point to the same IP in which the services are deployed (`xxx.xxx.xxx.xxx`), with a different port according to the service.

A firebase account must be set and configured with twitter and Google authentication provider.

To set up the firebase:
1. Sign in to Firebase https://firebase.google.com/. (use the same Google account and project as the one created 
   previously for the YouTube integration)
2. Click Go to console.
3. Use the project which was created previously on the YouTube integration section of the DAM. The project 
   configuration page is open on the firebase console.
4. In the Firebase console, open the Authentication section.
5. On the Sign in method tab, enable the Twitter and the Google provider (for the Google provider no more action is 
   needed).
6. [For twitter authentication] Add the API key and API secret from that provider's developer console to the provider 
   configuration:
a) Register your app as a developer application on Twitter(see DAM's section above) and get your app's OAuth API key and API secret.
b) Make sure your Firebase OAuth redirect URI (e.g. my-app-12345.firebaseapp.com/__/auth/handler) is set as your Authorization callback URL in your app's settings page on your Twitter app's config.
7. Click Save.
8. In the Authentication -- Settings add the domain of the node as an authorized one.
9. In the Project Overview -- Project Settings the auth_domain and the api key can be retrieved:
auth_domain=Project ID.firebaseapp.com
api_key=Web API Key
For more details please refer to [Firebase documentation](https://firebase.google.com/docs/auth/web/twitter-login).


```sh
REACT_APP_FIREBASE_AUTH_DOMAIN=<not commom>
REACT_APP_FIREBASE_API_KEY=<not common>
```

#### **e) IPFS API** 

IPFS bootstrap node:

```sh
IPFS_BOOTSTRAP_ADDR=<IPFS Bootstrap Node Identifier>
```

For example:

```sh
IPFS_BOOTSTRAP_ADDR=  /ip4/83.149.101.53/tcp/4001/p2p/12D3KooWGgFA2ZV4Uy7JUFMzs6VLCFZesPNtEpePHa3FbaX6MGHf
```

That parameter helps IPFS to discover the rest of the nodes in the neowork. For v1, `/ip4/83.149.101.53/tcp/4001/p2p/12D3KooWGgFA2ZV4Uy7JUFMzs6VLCFZesPNtEpePHa3FbaX6MGHf` will be used as bootstrap node for network discivery.

Local DAM address # It is the DOMAIN of the node + the DAM path as served by KONG GW 

```sh
DAM_ADDR=http://{DOMAIN_NAME}/dam
```

The following parameters can be left untouched:

```sh
IPFS_NODE_IP=ipfs_host # Container name of the IPFS Host service. Default: ipfs_host
IPFS_NODE_PORT=5001 # Port of the IPFS Host service. Default: 5001
IPFS_NODE_TIMEOUT=10
FSEARCH_RESULT_TIMEOUT=30
```

#### **f) Postfix** 
The following env variables must be in place before running the postfix container:

Variables with different value per node
```sh
DOMAIN_NAME=xxxxxx.yz # the email domain name
```

Variables with common value per node
```sh
TIMEZONE=est 
MESSAGE_SIZE_LIMIT=10240000 
AUTH_USER=mail_root
AUTH_PASSWORD=mail_password
DISABLE_SMTP_AUTH_ON_PORT_25=true
ENABLE_DKIM=true
DKIM_KEY_LENGTH=1024
DKIM_SELECTOR=default
```
More configuration options can be found at `https://github.com/takeyamajp/docker-postfix`
It is very important to set DKIM keys in DNS of the domain for the mails to be delivered succesfully.

#### **f) Kong Gateway**

The directory for the Kong Gateway configurations consists of the following sub-directories:

- postgres - In this sub-directory, there is the .env file that should be set for the postgres DB that KONG GW uses
  to store the data needed to work (default values are proposed below - can use these with no problem)

```sh
POSTGRES_USER=define the POSTGRES kong user | e.g. kong
POSTGRES_DB=define the POSTGRES kong DB | e.g. kong
POSTGRES_PASSWORD=define the POSTGRES kong user password | e.g. kongpass
```

- kong-migration - In this sub-directory, there is the .env file that should be set for the KONG GW postgres DB to
  bootstrap

The following parameters should be set (default values are proposed below - can use these with no problem):

```sh
KONG_DATABASE=postgres
KONG_PG_HOST= Should be the same as the container name of the postgres container, e.g. kong-database
KONG_PG_PASSWORD= Should be the same as the password defined as env var on postgres container, e.g. kongpass
KONG_PASSWORD= The default password used by the admin super user of the Kong Gateway. default = test
```

- kong-gateway - In this sub-directory, there is the .env file that should be set for the GW container to run

The following parameters should be set (default values are proposed below - can use these with no problem):
```sh
#KONG_PG_HOST=<define the postgres container name that kong GW uses> <e.g. kong-database>
#KONG_PG_USER=<define the kong-postgres user> <e.g. kong>
#KONG_PG_PASSWORD=<define the POSTGRES kong user's password> | <e.g. kongpass> the same as the one set in postgres .env
```

The following parameters can be left untouched:

```sh
KONG_DATABASE=postgres
#The following standard output/error env variables will only work on Unix environments
KONG_PROXY_ACCESS_LOG=/dev/stdout
KONG_ADMIN_ACCESS_LOG=/dev/stdout
KONG_PROXY_ERROR_LOG=/dev/stderr
KONG_ADMIN_ERROR_LOG=/dev/stderr
#The port that the Kong Admin API listens on for requests
KONG_ADMIN_LISTEN=0.0.0.0:8001
#The HTTP URL for accessing Kong Manager
KONG_ADMIN_GUI_URL=http://localhost:8002
```

- init - In this sub-directory, there are all the init commands that should be performed to configure KONG GW services 
  and routes

```sh
If permission denied error occurs when curl image executes init.sh script, navigate to /kong/init/ directory and run 
"chmod a+x *.sh"
```

#### **g) moderation UI** `./config/moderationui/.env`

The following URL should be defined:

URL FORMAT = {DOMAIN_NAME}/{COMPONENT_PATH}

```sh
# It is the DOMAIN of the node + /dam/
REACT_APP_API_URL=http://{DOMAIN_NAME}/{dam}/
```

### How to run it with Docker

Run the application, from the root level order:

```sh
docker-compose pull # pull the images
docker-compose up -d # run the docker-compose
```

### FAQ

1. I have updated the solr schema but the changes are not reflected. What can I do?

```sh
In some cases, the solr precreate script that is used for generating the solr core does not respect the provided configset.
For such cases it is recommended to manually copy the configset into the container:
eg. docker cp ./config/solr/mediaverse/conf/ solr-8-media-verse:/var/solr/data/mediaverse/
In general a conf folder is expected inside the data folder of the core.
```

2. I have added the ToS, Cookies and Privacy policy documents but they are not accessible

```sh
Please add SPRING_WEB_RESOURCES_STATIC-LOCATIONS=file:/static/ in the /Deployme/config/dam/.env
```