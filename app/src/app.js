require('./telemetry');
const express = require('express');
const morgan = require('morgan');
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

module.exports = app;
