HighlightView = require './HighlightView'

module.exports =
class ErrorView extends HighlightView

  @className: 'refactor-error'
  configProperty: 'coffee-refactor.highlightError'

  constructor: ->
    super
