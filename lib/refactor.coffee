RefactorView = require './refactor-view'
{ satisfies } = require 'semver'
{ readFileSync } = require 'fs'
{ allowUnsafeEval } = require 'loophole'
cson =  allowUnsafeEval -> require 'cson'
console.log require('util').inspect cson

isFunction = (func) -> typeof func is 'function'

module.exports =
  refactorView: null
  modules: []

  activate: (state) ->
    packageManager = atom.packages
    { version } = JSON.parse readFileSync 'package.json'

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

    atom.workspaceView.command '', @onRename
    atom.workspaceView.command '', @onDone

  deactivate: ->
    @refactorView.destroy()

  serialize: ->
    refactorViewState: @refactorView.serialize()
