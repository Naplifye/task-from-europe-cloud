const express = require('express');
const mongoose = require('mongoose');

const app = express();

app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: false }));

// Get MongoDB connection details from environment variables
const MONGODB_MASTER = process.env.MONGODB_MASTER;
const MONGODB_SLAVE = process.env.MONGODB_SLAVE;
const MONGODB_ARBITER = process.env.MONGODB_ARBITER;

// Connect to MongoDB
mongoose
  .connect(
    `mongodb://admin:admin@${MONGODB_MASTER}:27017,${MONGODB_SLAVE}:27018,${MONGODB_ARBITER}:27019/docker-node-mongo?replicaSet=rs0`,
  )
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err));

const Item = require('./models/item.js');

app.get('/', (req, res) => {
  Item.find()
    .then(items => res.render('index', { items }))
    .catch(err => res.status(404).json({ msg: 'No items found' }));
});

app.post('/item/add', (req, res) => {
  const newItem = new Item({
    name: req.body.name
  });

  newItem.save().then(item => res.redirect('/'));
});

const port = 3000;

app.listen(port, () => console.log('Server running...'));