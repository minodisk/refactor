RefactorView = require './refactor-view'
{ satisfies } = require 'semver'
{ readFileSync } =require 'fs'

module.exports =
  refactorView: null

  activate: (state) ->
    packageManager = atom.packages

    { version } = JSON.parse readFileSync 'package.json'

    for metaData in packageManager.getAvailablePackageMetadata()
      { name, engines } = metaData
      continue unless !packageManager.isPackageDisabled(name) and
                      (requiredVersion = engines?.refactor)? and
                      satisfies version, requiredVersion

      packageManager
      .activatePackage name
      .then (pkg) ->
        console.log require('util').inspect pkg.mainModule

    @refactorView = new RefactorView state.refactorViewState

  deactivate: ->
    @refactorView.destroy()

  serialize: ->
    refactorViewState: @refactorView.serialize()
