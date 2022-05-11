db = db.getSiblingDB('${MONGO_DB_NAME}');

db.createUser(
  {
      user: '${MONGO_ROOT_USERNAME}',
      pwd: '${MONGO_ROOT_PASSWORD}',
      roles: [
          {
              role: "readWrite",
              db: "root_db"
          }
      ]
  }
);
