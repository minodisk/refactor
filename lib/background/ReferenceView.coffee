HighlightView = require './HighlightView'

module.exports =
class ReferenceView extends HighlightView

  @className: 'refactor-reference'
  configProperty: 'coffee-refactor.highlightReference'

  constructor: ->
    super
