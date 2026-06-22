const request = require('supertest')
const app = require('../app')

describe('Health endpoints', () => {
  test('GET /health returns 200', async () => {
    const res = await request(app).get('/health')
    expect(res.statusCode).toBe(200)
    expect(res.body.status).toBe('healthy')
  })

  test('GET /ready returns 200', async () => {
    const res = await request(app).get('/ready')
    expect(res.statusCode).toBe(200)
    expect(res.body.status).toBe('ready')
  })
})
