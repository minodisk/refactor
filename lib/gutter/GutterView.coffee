{ $ } = require 'atom'

module.exports =
class GutterView

  constructor: (@gutter) ->

  destruct: ->
    #TODO implement


  empty: ->
    @gutter.removeClassFromAllLines 'coffee-refactor-error'
    @gutter
    .find '.line-number .icon-right'
    .attr 'title', ''

  update: (errors) ->
    @empty()
    return unless errors?
    for { range, message } in errors
      $ @gutter.getLineNumberElement range.start.row
      .addClass 'coffee-refactor-error'
      .attr 'title', message
