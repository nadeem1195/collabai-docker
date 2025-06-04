// Create admin user in admin database
db = db.getSiblingDB('admin');

// Create admin user first
try {
  db.createUser({
    user: "admin",
    pwd: "x0G319JFlnWNgs",
    roles: [
      { role: "dbAdminAnyDatabase", db: "admin" },
      { role: "readWriteAnyDatabase", db: "admin" },
      { role: "userAdminAnyDatabase", db: "admin" }
    ]
  });
} catch (error) {
  print("Admin user might already exist, continuing...");
}

// Switch to admin database and authenticate
db.auth("admin", "x0G319JFlnWNgs");

// Create collabai user
try {
  db.createUser({
    user: "collabai",
    pwd: "xpjE8OTMse48",
    roles: [
      { role: "dbAdmin", db: "collabai" },
      { role: "readWrite", db: "collabai" },
      { role: "userAdmin", db: "collabai" }
    ]
  });
} catch (error) {
  print("Collabai user might already exist, continuing...");
}

// Create and switch to the application database
db = db.getSiblingDB('collabai');
db.createCollection('init'); 