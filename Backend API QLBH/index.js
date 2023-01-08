'use strict';
const express = require('express');
const config = require('./config');
const cors = require('cors');
const bodyParser = require('body-parser');
const QLBHRoutes = require('./routes/QLBHRoutes');

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.use('/api', QLBHRoutes.routes);

app.listen(config.port, () => {
  console.log('app listening on url http://localhost:' + config.port )
});