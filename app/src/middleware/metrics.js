const { httpRequestDuration, httpRequestsTotal } = require('../routes/health');

function metricsMiddleware(req, res, next) {
  const end = httpRequestDuration.startTimer();
  res.on('finish', () => {
    const labels ={
      method: req.method,
      route: req.baseUrl + (req.route?.path || ''),
      status_code: res.statusCode,
    };
    end(labels);
    httpRequestsTotal.inc({
      method: req.method,
      route: req.baseUrl + (req.route?.path || ''),
      status: res.statusCode,
    });
  });
  next();
}

module.exports = metricsMiddleware;
