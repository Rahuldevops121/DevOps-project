const client = require('prom-client');

const itemsCreated = new client.Counter({
  name: 'items_created_total',
  help: 'Total items created through API',
});

module.exports = {
  itemsCreated,
};
