db = db.getSiblingDB('docker-node-mongo');

db.createUser({ 
    user: 'admin',
    pwd: 'admin',
    roles: [{ role: 'readWrite', db: 'docker-node-mongo' }] 
}, { w: 'majority', wtimeout: 5000 });