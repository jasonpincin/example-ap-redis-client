const http = require('http')
const piloted = require('piloted')
const Redis = require('ioredis')

let redis

main()
async function main () {
    await piloted.config(require('./containerpilot.json'))
    configureRedis()
    piloted.on('refresh', configureRedis)

    const server = http.createServer(onRequest)
    server.listen(8000)
}

async function onRequest (req, res) {
    try {
        const value = await redis.get('test:key')
        res.end(`The test:key is: ${value}`)
    }
    catch (err) {
        res.statusCode = 500
        res.end(`An error occurred: ${err.message}`)
    }
}

function configureRedis () {
    if (redis) redis.quit()
    const sentinels = piloted.serviceHosts('redis-sentinel')
    redis = new Redis({ sentinels, name: 'mymaster' })
}
