
# MediaVerse

## Introduction

[MediaVerse](https://mediaverse-project.eu/) is funded under the Horizon2020 scheme of the European Commission.
The goal of this project is to set up a decentralized network of content management nodes through which content owners and creators can easily exchange content and negotiate media rights while next generation authoring tools and innovative collaboration spaces foster the creation of personalised, immersive and accessible future media experiences.

### What’s the idea?

In the first years of this century a phenomenon called Web 2.0 began to enable virtually everyone to create and publish content without technical background. Creating websites had already been easy – then the blogosphere opened the world of text publishing, image exchange, and even video publishing became easier than ever. Everything was for free, both publishing and consuming. Since then, a few social media companies have risen to dominate the world of content creation offering tools and services to create and publish all sorts of media – largely under their control.

This is where MediaVerse comes in: MediaVerse aims to enable all sorts of content creators, from traditional publishers and freelance creators or artists to anyone who wants to share their ideas, to create and share their media, while keeping control of their intellectual property rights. MediaVerse aims to provide a set of tools to support all steps in this process:

- Co-creation tools, where multiple users can work on their projects together, supporting also immersive media like interactive 360° videos and 3D objects;
- Social analytics tools to follow the trends and connect with your existing Social Media channels both ways – re-using the media you posted there as well as posting your new creations;
- A decentralized network to share the media;
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
..fader
..ipfs_api
..ipfs_host
..kong
..moderationui
..mongo
..omaf
..postfix
..prometheus
..right-management
..solr
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

`Set mongo db parameters:` 

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

`Set asset storage:`

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

`Set the domain of the node`

The domain or IP of the DAM has to be configured. This value is used to generate proxy format links and deep links.

```sh
DAM_DOMAIN=<not common> # It is the DOMAIN of the node + the DAM path as served by KONG GW
```

For example:

```sh
DAM_DOMAIN=http://{DOMAIN_NAME}/dam
```

`Set the security secret of the node`

This is a string that will be used to sign the jwt tokens that are used for authentication and authorization purposes.

```sh
JWT_SECRET={32 characters long String}
```

For example:

```sh
JWT_SECRET=x7aiYOMPMDdoJj4XjQnR4CmmbYCdimTT
```


`Set the name of the node`
 A characteristic name for the node should be specified. This facilitates federated search as the retrieved assets are tagged with the name of the node, alongside its domain name or IP.

```sh
DAM_NAME=<not commom> 
# For example:
DAM_NAME=atc-vm.gr
```

`Set maximum file size limit`
Maximum file size limit can also be set:
```sh
SPRING_SERVLET_MULTIPART_MAX-FILE-SIZE=25MB # meaning total file size cannot exceed 25MB.
SPRING_SERVLET_MULTIPART_MAX-REQUEST-SIZE=25MB #meaning total request size for a multipart/form-data cannot exceed 128KB.
## If not set 25MB will be the default
```

`Set the Twitter configuration`
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

`Set the Youtube configuration`
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

`Set the Truly Media configuration`
For setting up the connection with Truly Media platform:

1. Request a new TRULY_ORGANIZATION_API_KEY from Truly Media personnel by sending a mail to support@truly.media
2. After receiving the key include the below two env variables

```sh 
TRULY_ORGANIZATION_API_KEY = <key received by Truly media>
TRULY_DOMAIN = <the domain of the Truly Media platform>
```
Please also notice that Truly Media platform requires a Twitter account to be present otherwise the user will not be able to sign in to the platform.

`Set the mail configuration`
```sh
MAIL_USERNAME=mail_root@DOMAIN_EMAIL_NAME # a generic user for connecting to smtp, the DOMAIN_EMAIL_NAME must be the same as the one that will be set for postfix service
MAIL_PASSWORD=mail_password # a generic password
MAIL_HOST=postfix # the name of the postfix service
```
`Keep the below values unless there is a good reason to modify them`
The following parameters can be left untouched:

```sh
SOLR_URL=http://solr:8983/solr # the same for all nodes. 
IPR_URL=http://ipr-service:8081 # the same for all nodes
IPFS_URL=http://ipfs_host:5001/api/v0/ # the same for all nodes
TRANSCODER_URL=http://transcoder:5000 # the same for all nodes
CMRR_URL=http://cmrr:8007 # the same for all nodes
HATESPEECH_URL=https://services.atc.gr # the same for all nodes
NDD_URL=https://mever.iti.gr/ndd/api/v3 # the same for all nodes
GRPC_URL=apis.mever.gr:443 # the same for all nodes
SERVER_PORT=8888 # the same for all nodes

RACU_KEY=<available upon request / provided by SWISSTEXT>
SPRING_WEB_RESOURCES_STATIC-LOCATIONS=file:/static/


```

#### **c) Right-Management components:**

##### Setup mv-cicero-template-library
mv-cicero-template-library has been configured as a git submodule which will be cloned at `Deployme/config/right-management/mv-cicero-template-library`.  
The below command can be used for cloning the submodule:
```sh
 git submodule update --init --recursive --remote
```

##### Parameters that shall be configured

---

A) `Deployme/config/right-management/ipr-service/application.yml`

The bearer token that will be used for authenticating IPR service against DAM (`mv-services-bearer-tokens.mediaverse-node-backend` property) must be set.  
The process for generating the bearer token is:
1.  Take the JWT_SECRET that has been defined in b)(DAM) section
2.  Go to https://jwt.io/ and put it in the VERIFY SIGNATURE
3.  Add the following payload 
{
  "id": "6242a8e2e945ee72da204ef9",
  "email": "ipr@mediaverse.org",
  "username": "ipr"
}
4.  Keep the other default values
5.  Copy the value of the generated jwt token from the encoded section


The bearer token that will be used for authenticating IPR service against Blockchain Service Provider (BCSP) must be set.  
To generate the bearer token use:

```
docker run -it --rm mediaverse/mv-blockchain:4.0.1 npm run generatetoken
```

> N.B. Keep the `TOKEN_SECRET="..."` for the next step.

Both the bearer tokens shall be set in the relative section of the configuration file (`Deployme/config/right-management/ipr-service/application.yml`):

```sh
mv-services-bearer-tokens:
  mediaverse-node-backend: {DAM jwt token defined above}  #bearer token of the IPR Service (to make requests to DAM)
  mv-blockchain-service-provider: {BCSP jwt token defined above} #bearer token of the IPR Service (to make requests to BCSP)
```

---

B) `Deployme/config/right-management/mv-bcsp/.env`

For the **development** environment, paste the text below inside `Deployme/config/right-management/mv-bcsp/.env` and replace `DEFAULT_MV_NODE_PRIVATE_KEY` and `TOKEN_SECRET` values with yours:

```sh
NODE_ENV=mv-eth
DEFAULT_MV_NODE_PRIVATE_KEY=MV-NODE-PRIVATE-KEY
TOKEN_SECRET="SECRET-KEY-GENERATED-IN-PREVIOUS-STEP"
```

For the **production** environment, follow these steps:

1. Create an account on [INFURA](https://infura.io/) and generate a new API key.

2. Give a project Name and select **Web3 API** as network.

3. Clear BCSP configuration with this command:

```
docker run -v Deployme/config/right-management/mv-bcsp/config/:/mv-blockchain-service-provider/config/ -it --rm mediaverse/mv-blockchain:4.0.1 npm run preparedeploy
```

4. If you do not have your own wallet, you **must create a new one** with the command:

```
docker run -v Deployme/config/right-management/mv-bcsp/config/:/mv-blockchain-service-provider/config/ -it --rm mediaverse/mv-blockchain:4.0.1 npm run createwallet
```

**NOTE: you will be asked to enter a password to encrypt the wallet. After that, the wallet address will be printed out, store it somewhere, you will need it to recharge with ETH. Meanwhile, the password you have entered will have to be written into the WALLET_PW field inside the `Deployme/config/right-management/mv-bcsp/.env` file (see next step). The wallet must have ETH on the chosen testnet to allow the BCSP to deploy and interact with the contracts. You can gain SepoliaETH for free by using [Infura faucet](https://www.infura.io/faucet/sepolia) using the wallet address given in the previous step. We suggest that you have at least 1 SepoliaETH to allow contracts to be correctly deployed onto the blockchain network. In addition, the admin must periodically check the availability of SepoliaETH to ensure the correct execution of transactions.**

5. Paste the text below inside `Deployme/config/right-management/mv-bcsp/.env` and replace `INFURA_API_KEY`, `TOKEN_SECRET` and `WALLET_PW` values with yours:

```sh
NODE_ENV="production" 
DEFAULT_NETWORK="sepolia"
INFURA_API_KEY="YOUR-INFURA-API-KEY"
TOKEN_SECRET="SECRET-KEY-GENERATED-IN-PREVIOUS-STEP"
WALLET_PW="WALLET-PASSWORD-USED-DURING-WALLET-GENERATION"
```

---

##### Below configurations can be left untouched

---

A) `Deployme/config/right-management/ipr-service/application.yml`

```sh
spring:
  jackson:
    default-property-inclusion: NON_NULL  #ObjectMapper property inclusion (do not change)

logging:
  level:
    root: INFO  #define the level of logging: ERROR > WARN > INFO > DEBUG > TRACE

debug:
  disable-slc-confirmation-check: false #disable the blockchain confirmation event check

server:
  port: 8081  #port on which ipr-service is listening
  error:
    include-message: always  #enable error detailed description
    include-stack-trace: 1  #enable stack-trace in errors description

mv-services-basepaths:
  mv-blockchain-service-provider: http://mv-bcsp:8082/ipr/bc  #endpoint of the BCSP
  mv-slc-engine: http://mv-slc-engine:8083  #endpoint of the MV SLC Engine
  mediaverse-node-backend: http://mv-dam-api:8888  #endpoint of the MV Node Backend
  content-discovery-services-and-copyrights-negotiation: http://copyright-negotiation:3003  #endpoint of the License Comparator

mv-services-clients-timeouts:
  connect-timeout: 60  #in seconds
  read-timeout: 60  #in seconds

```

---

B) `Deployme/config/right-management/mv-slc-engine/application.yml`

```sh

logging:
  level:
    root: INFO  #define the level of logging: ERROR > WARN > INFO > DEBUG > TRACE

server:
  port: 8083  #port on which mv-slc-engine is listening
  error:
    include-message: always  #enable error detailed description
    include-stack-trace: 1  #enable stack-trace in errors description

debug:
  ignore-derivative-work-ownership: true  #to enable nested derivative works

mv-services-clients-timeouts:
  connect-timeout: 60  #in seconds
  read-timeout: 60  #in seconds

mv-services-basepaths:
  cicero-server: http://cicero-server:6001  #endpoint of the cicero-server

slc-templates:
  library-dir: /mv-cicero-template-library  #path of the SLC templates library (inside the container)

```

---

C) `Deployme/config/right-management/cicero-server/.env`

```sh
CICERO_PORT=6001  #port on which cicero-server is listening
CICERO_DIR=/mv-cicero-template-library  #path of the SLC templates library (inside the container)
```
---

D) `Deployme/config/right-management/mv-bcsp/config/config.json`  
> N.B. It shall be empty during first run.
```sh
{

}
```

---

F) `Deployme/config/right-management/mv-bcsp/.env`

```sh
RPC_CONNECTION_TIMEOUT=60000  #timeout of the RPC
```

---

E) `Deployme/config/right-management/mv-bcspeh/.env`

For the **development** environment, paste the text below inside `Deployme/config/right-management/mv-bcspeh/.env`:

```sh
NODE_ENV=mv-eth  #name of the docker service container of the local blockchain deployment
IPR_SERVICE_ENDPOINT=http://ipr-service:8081/  #endpoint of the IPR Service
UPDATE_API_ENDPOINT=event/update  #path of the event update API of the IPR Service
```

For the **production** environment, paste the text below inside `Deployme/config/right-management/mv-bcspeh/.env` and replace `INFURA_API_KEY` value with your:

```sh
NODE_ENV="production" 
DEFAULT_NETWORK="sepolia"
INFURA_API_KEY="YOUR-INFURA-API-KEY"
IPR_SERVICE_ENDPOINT=http://ipr-service:8081/  #endpoint of the IPR Service
UPDATE_API_ENDPOINT=event/update  #path of the event update API of the IPR Service
```

#### **d) UI** `./config/ui/.env`

The following URLs should be defined:

URLS FORMAT = {DOMAIN_NAME}/{COMPONENT_PATH}

```sh
# It is the DOMAIN of the node + /dam
REACT_APP_API_URL=https://{DOMAIN_NAME}/{dam}
# It is the DOMAIN of the node + /copyright 
REACT_APP_LICENSES_URL=https://{DOMAIN_NAME}/{copyright}
# It is the DOMAIN of the node + /ipr
REACT_APP_IPR_URL=https://{DOMAIN_NAME}/{ipr}
# It is the DOMAIN of the node + /ipfs
REACT_APP_FEDSE_URL=wss://{DOMAIN_NAME}/{ipfs}
REACT_APP_NODE_URL=https://{DOMAIN_NAME}
# It is the DOMAIN of the node + /template-studio
REACT_APP_SLC_STUDIO=https://{DOMAIN_NAME}/{template-studio}
# It is the maximum file size used during uploading
REACT_APP_FILE_SIZE_UPLOAD_LIMIT=1024
REACT_APP_FADER_URL=https://fader360.vrgmnts.net/users/mv-login
# It is the DOMAIN of the VRodos service
REACT_APP_VRODOS_URL=https://vrodos.iti.gr/mv-login
# It is the DOMAIN of the NERstar tool
REACT_APP_NERSTAR_URL=https://nerstar.sandec.de
```


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

The IPFS bootstrap node parameter helps IPFS to discover the rest of the nodes in the network. 
```sh
IPFS_BOOTSTRAP_ADDR=<IPFS Bootstrap Node Identifier>
```
`/ip4/83.149.101.53/tcp/4001/p2p/12D3KooWNRQZc9NtFVPFyG4F4jirXCkJ1vp4iDkgVHr3Ao9Efo1t` will be used as bootstrap node for network discovery. To define it, the following shall be added in the .env file. 

```sh
IPFS_BOOTSTRAP_ADDR=/ip4/83.149.101.53/tcp/4001/p2p/12D3KooWNRQZc9NtFVPFyG4F4jirXCkJ1vp4iDkgVHr3Ao9Efo1t
```

The following parameters can be left untouched:

```sh
IPFS_NODE_IP=ipfs_host # Container name of the IPFS Host service. Default: ipfs_host
IPFS_NODE_PORT=5001 # Port of the IPFS Host service. Default: 5001
IPFS_NODE_TIMEOUT=10
FSEARCH_RESULT_TIMEOUT=30
DAM_ADDR=http://mv-dam-api:8888
NDD_ADDR=https://mever.iti.gr
EXPOSE_CONTENT=True
MAX_WORKERS_NUM=4
```

#### **f) IPFS HOST** 

Common for all nodes:
```sh
LIBP2P_FORCE_PNET=1
IPFS_PROFILE=server
IPFS_SWARM_KEY_FILE=/data/ipfs/myswarm.key
```

#### **g) Postfix (optional)** 
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
It is very important to set DKIM keys in DNS of the domain for the mails to be delivered successfully.

#### **h) Kong Gateway**

The directory for the Kong Gateway configurations consists of the following sub-directories:

- postgres - In this sub-directory, there is the .env file that should be set for the postgres DB that KONG GW uses
  to store the data needed to work (default values are proposed below)

```sh
POSTGRES_USER=define the POSTGRES kong user | e.g. kong
POSTGRES_DB=define the POSTGRES kong DB | e.g. kong
POSTGRES_PASSWORD=define the POSTGRES kong user password | e.g. kongpass
```

- kong-migration - In this sub-directory, there is the .env file that should be set for the KONG GW postgres DB to
  bootstrap

The following parameters should be set (default values are proposed below):

```sh
KONG_DATABASE=postgres
KONG_PG_HOST= Should be the same as the container name of the postgres container, e.g. kong-database
KONG_PG_PASSWORD= Should be the same as the password defined as env var on postgres container, e.g. kongpass
KONG_PASSWORD= The default password used by the admin super user of the Kong Gateway. default = test
```

- kong-gateway - In this sub-directory, there is the .env file that should be set for the GW container to run

The following parameters should be set (default values are proposed below):
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

#### **i) moderation UI** `./config/moderationui/.env`

The following URL should be defined:

URL FORMAT = {DOMAIN_NAME}/{COMPONENT_PATH}

```sh
# It is the DOMAIN of the node + /dam/
REACT_APP_API_URL=http://{DOMAIN_NAME}/{dam}/
```

#### **j) Fader** `./config/fader/.env`

The following should be defined:
```sh
PHX_SERVER="true"
FADER360_BACKEND_VERSION=<Version number is imp to specify the image from which the container should run>
FADER360_BACKEND_VERSION_NUMBER=<Version number is imp because of the verion dependent assets and preview assets path inside the container>
# eg. FADER360_BACKEND_DATABASE_URL=ecto://postgres:postgres@vragments-db/faderomafdb
FADER360_BACKEND_DATABASE_URL=<ecto database url, see https://hexdocs.pm/ecto/Ecto.Repo.html#module-urls>
# could be any 64 long string
FADER360_BACKEND_SECRET_KEY_BASE=<encryption secret, can be generated via https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html>
FADER360_BACKEND_SCHEME=<url scheme, e.g. https>
FADER360_BACKEND_HOST=<url domain, e.g. fader360.vrgmnts.net>
FADER360_BACKEND_PORT=<url port, e.g. 443>
FADER360_BACKEND_CONTAINER_PORT=<application listening port inside container, e.g.: 17000>
```

#### **k) MV Omaf** `./config/moderationui/.env`

The following should be defined:
```sh
PHX_SERVER="true"
MV_OMAF_VERSION=<Version number is important because of version dependent asset path inside container>
MV_OMAF_DATABASE_URL=<ecto database url, see https://hexdocs.pm/ecto/Ecto.Repo.html#module-urls>
MV_OMAF_SECRET_KEY_BASE=<encryption secret, can be generated via https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html>
MV_OMAF_SCHEME=<url scheme, e.g. https>
MV_OMAF_HOST=<url domain, e.g. mv_omaf.vrgmnts.net>
MV_OMAF_PORT=<url port, e.g. 443>
MV_OMAF_CONTAINER_PORT=<application listening port inside container, e.g.: 16000>
MV_OMAF_TRANSCODED_ASSETS_PATH=<version dependent asset path inside container, must be: '/root/mv_omaf_release/lib/mv_omaf_web-VERSION/priv/static/assets/mv_omaf_transcoded_files', VERSION must match image version, whole string must match mounted volume>
```

#### **l) monitoring tools** 

For monitoring the node, prometheus and grafana tools are supported.
Firstly the prometheus component must be set:
./config/prometheus/prometheus.yml must be included. The default settings are fine and they can be customized as well,
eg. the scraping interval.
Prometheus will be configured to listen to the DAM traffic.
The prometheus plugin must be set by ordering:
```sh
curl -X POST http://localhost:8001/routes/dam-route/plugins \
    --data "name=prometheus"  \
    --data "config.per_consumer=false"
```
Reference : `https://docs.konghq.com/hub/kong-inc/prometheus/configuration/examples/`

The prometheus interface will be available at:
`http://<IP>:9090/targets?search=`

After that the grafana component must be set to add Prometheus as a data source and the official Kong Dashboard to
be imported.
Grafana UI can be accessed at:
`http://<IP>:9000/`
The default username and password for Grafana is admin / admin .
The dashboard json can be downloaded here:
https://grafana.com/api/dashboards/7424/revisions/7/download
And the process of importing it to the grafana service is the below:
1.  Open your Grafana portal and go to the option of importing a dashboard.
2.  Go to the “Upload JSON file” button, select the kong-official_rev7.json which you got from the url above.
3.  Configure the fields according to your preferences and click on Import.

The dashboard will be ready.


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

3. Blockchain module(mv-bcsp) fails to start

```sh
Please initialize Deployme/config/right-management/mv-bcsp/config/config.json to {}
This shall not be used in case of a real setup with an external blockchain network (i.e., the Ethereum network).
In fact, if the config is re-initialised with an empty object, the Blockchain Smart Contracts will be deployed again.
Therefore, the values in the JSON config file shall be carefully stored in a safe place in order to be restored if 
needed (rather than generating new ones).
```

3. Kong cannot route traffic to internal fader

```sh
Please order:
curl --request PATCH --url 0.0.0.0:8001/services/fader360-service --data url=http://fader360-reverseproxy
(recreate also kong)
```