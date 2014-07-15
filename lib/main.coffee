RefactorView = require './refactor-view'
{ satisfies } = require 'semver'
{ readFileSync } = require 'fs'
{ allowUnsafeEval } = require 'loophole'
# { parseFileSync } =  allowUnsafeEval -> require 'cson'
# console.log require('util').inspect cson
Watcher = require './Watcher'
{ packages: packageManager, config } = atom

module.exports =
new class Main

  renameCommand: 'refactor:rename'
  doneCommand: 'refactor:done'

  configDefaults:
    highlightError    : true
    highlightReference: true


  ###
  Life cycle
  ###

  activate: (state) ->
    @updateModules()
    config.on 'updated.core-disabledPackages', @updateModules

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

  updateModules: ->
    isFunction = (func) -> typeof func is 'function'
    { version } = JSON.parse readFileSync 'package.json'

    @modules = []

    # Search packages related to refactor package.
    for metaData in packageManager.getAvailablePackageMetadata()
      # Verify enabled, defined in engines, and satisfied version.
      { name, engines } = metaData
      continue unless !packageManager.isPackageDisabled(name) and
                      (requiredVersion = engines?.refactor)? and
                      satisfies version, requiredVersion

      packageManager
      .activatePackage name
      .then (pkg) =>
        # Verify module interface.
        { scopeNames, parse, find } = module = pkg.mainModule
        console.log scopeName, parse, find
        unless Array.isArray(scopeNames) and isFunction(parse) and isFunction(find)
          console.error 'Refactor package should implement scopeNames, parse() and find()'
          return
        @modules.push module

  onCreated: (editorView) =>
    watcher = new Watcher editorView
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
