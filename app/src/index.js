const express = require('express');
const morgan = require('morgan');
const config = require('./config/config');
const logger = require('./middleware/logger');
const { router: healthRouter } = require('./routes/health');
const apiRouter = require('./routes/api');
const metricsMiddleware = require('./middleware/metrics');

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined', { stream: { write: msg => logger.info(msg.trim()) } }));
app.use(metricsMiddleware);
app.use('/', healthRouter);
app.use('/api/v1', apiRouter);

app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(500).json({ success: false, message: 'Internal Server Error' });
});

const server = app.listen(config.port, () => {
  logger.info(`🚀 ${config.appName} running on port ${config.port}`);
  logger.info(`📊 Metrics: http://localhost:${config.port}/metrics`);
  logger.info(`🛠️  API: http://localhost:${config.port}/api/v1/info`);
});

module.exports = { app, server };
