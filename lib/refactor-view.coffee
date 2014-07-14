{View} = require 'atom'

module.exports =
class RefactorView extends View
  @content: ->
    @div class: 'refactor overlay from-top', =>
      @div "The Refactor package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "refactor:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "RefactorView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
