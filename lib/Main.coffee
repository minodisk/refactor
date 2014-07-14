module.exports =
class Main

  Watcher: null
  renameCommand: ''
  doneCommand: ''

  configDefaults:
    highlightError    : true
    highlightReference: true


  ###
  Life cycle
  ###

  activate: (state) ->
    @watchers = []
    atom.workspaceView.eachEditorView @onCreated
    atom.workspaceView.command @renameCommand, @onRename
    atom.workspaceView.command @doneCommand, @onDone

  deactivate: ->
    atom.workspaceView.off @renameCommand, @onRename
    atom.workspaceView.off @doneCommand, @onDone
    for watcher in @watchers
      watcher.destruct()
    delete @watchers

  serialize: ->


  ###
  Events
  ###

  onCreated: (editorView) =>
    watcher = new @Watcher editorView
    watcher.on 'destroyed', @onDestroyed
    @watchers.push watcher

  onDestroyed: (watcher) =>
    watcher.destruct()
    @watchers.splice @watchers.indexOf(watcher), 1

  onRename: (e) =>
    isExecuted = false
    for watcher in @watchers
      isExecuted or= watcher.rename()
    return if isExecuted
    e.abortKeyBinding()

  onDone: (e) =>
    isExecuted = false
    for watcher in @watchers
      isExecuted or= watcher.done()
    return if isExecuted
    e.abortKeyBinding()
