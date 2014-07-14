RefactorView = require './refactor-view'

module.exports =
  refactorView: null

  activate: (state) ->
    @refactorView = new RefactorView(state.refactorViewState)

  deactivate: ->
    @refactorView.destroy()

  serialize: ->
    refactorViewState: @refactorView.serialize()
