db = db.getSiblingDB('docker-node-mongo');

db.items.insertMany([
    { name: 'Mouse', price: 29.99, brand: 'TechBrand', inStock: true },
    { name: 'Keyboard', price: 59.99, brand: 'KeyCorp', inStock: false }
])

db.createUser({ 
    user: 'admin',
    pwd: 'admin',
    roles: [{ role: 'readWrite', db: 'docker-node-mongo' }] 
}, { w: 'majority', wtimeout: 5000 });