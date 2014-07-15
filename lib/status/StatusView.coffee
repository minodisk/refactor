{ View } = require 'atom'

module.exports =
class StatusView extends View

  @content: ->
    @div class: 'refactor-status inline-block', =>
      @span class: 'lint-name'
      @span class: 'lint-summary'

  constructor: ->
    super()

    @find('.linter-name')
    @find('.linter-name')

  destruct: ->
    #TODO implement
