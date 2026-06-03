const express = require('express');
const router = express.Router();
const logger = require('../middleware/logger');
const config = require('../config/config');

router.get('/info', (req, res) => {
  logger.info('Info endpoint hit');
  res.status(200).json({
    app: config.appName,
    version: config.appVersion,
    environment: config.nodeEnv,
    message: 'DevOps Platform App is running!',
  });
});

router.get('/items', (req, res) => {
  const items = [
    { id: 1, name: 'Item One', status: 'active' },
    { id: 2, name: 'Item Two', status: 'inactive' },
    { id: 3, name: 'Item Three', status: 'active' },
  ];
  res.status(200).json({ success: true, count: items.length, data: items });
});

router.post('/items', (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ success: false, message: 'Name is required' });
  res.status(201).json({ success: true, data: { id: Date.now(), name, status: 'active' } });
});

module.exports = router;
