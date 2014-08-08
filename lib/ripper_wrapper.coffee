{ isMaster } = cluster = require 'cluster'

if cluster.isMaster
  console.log 'master'
  worker = cluster.fork()
  worker.on 'message', (msg) ->
    console.log msg
  worker.send 'hi there'
else if cluster.isWorker
  console.log 'worker'
  process.on 'message', (msg) ->
    process.send msg

{ join } = require 'path'

worker = new Worker join __dirname, 'worker.js'
