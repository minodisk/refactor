atom = require 'atom'

module.exports =
class View extends atom.View

  destruct: ->
    @remove()
