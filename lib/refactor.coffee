RefactorView = require './refactor-view'
{ satisfies } = require 'semver'
{ readFileSync } = require 'fs'
{ allowUnsafeEval } = require 'loophole'
# { parseFileSync } =  allowUnsafeEval -> require 'cson'
# console.log require('util').inspect cson

isFunction = (func) -> typeof func is 'function'

module.exports =
  refactorView: null
  modules: []

  activate: (state) ->
    packageManager = atom.packages
    { version } = JSON.parse readFileSync 'package.json'

    packageManager.on 'activated', (e) ->
      console.log 'activated'

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
        # Verify interface.
        { parse, find } = module = pkg.mainModule
        return unless isFunction(parse) and isFunction(find)
        @modules.push module

    @refactorView = new RefactorView state.refactorViewState

    atom.workspaceView.command 'refactor:rename', @rename
    atom.workspaceView.command 'refactor:done', @done

  deactivate: ->
    atom.workspaceView.off 'refactor:rename', @rename
    atom.workspaceView.off 'refactor:done', @done

    @refactorView.destroy()

  serialize: ->
    refactorViewState: @refactorView.serialize()

  rename: (e) ->
    console.log 'rename'

  done: (e) ->
    console.log 'done'
