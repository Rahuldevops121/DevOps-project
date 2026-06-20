const app = require('./app');
const config = require('./config/config');
const logger = require('./middleware/logger');

const server = app.listen(config.port, () => {
  logger.info(`🚀 ${config.appName} running on port ${config.port}`);
  logger.info(`📊 Metrics: http://localhost:${config.port}/metrics`);
  logger.info(`🛠️  API: http://localhost:${config.port}/api/v1/info`);
});

module.exports = { app, server };
