{ isMaster } = cluster = require 'cluster'


class ParentProcess

  constructor: (@Ripper) ->

class ChildProcess

  constructor: (@Ripper) ->

if isMaster
  module.exports = ParentProcess
  cluster.on 'death', ->
    worker = cluster.fork()
    worker.on 'message', (msg) ->
else
  module.exports = ChildProcess
  process.send cmd: 'foo'
  process.send cmd: 'close'
  process.exit 0
