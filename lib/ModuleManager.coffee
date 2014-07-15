{ satisfies } = require 'semver'
{ EventEmitter2 } = require 'eventemitter2'
{ config, packages: packageManager } = atom

isFunction = (func) -> (typeof func) is 'function'

module.exports =
class ModuleManager extends EventEmitter2

  modules: {}
  version: '0.0.0'

  constructor: ->
    super
    #TODO update when package is enabled
    # config.on 'updated.core-disabledPackages', @update
    #TODO read version from package.json
    # { @version } = JSON.parse readFileSync 'package.json'
    @update()

  destruct: ->
    # config.off 'updated.core-disabledPackages', @update

    delete @modules

  update: =>
    @modules = {}
    # Search packages related to refactor package.
    for metaData in packageManager.getAvailablePackageMetadata()
      # Verify enabled, defined in engines, and satisfied version.
      { name, engines } = metaData
      continue unless !packageManager.isPackageDisabled(name) and
                      (requiredVersion = engines?.refactor)? and
                      satisfies @version, requiredVersion
      @activate name

  activate: (name) ->
    packageManager
    .activatePackage name
    .then (pkg) =>
      # Verify module interface.

      { scopeNames, parse, find } = module = pkg.mainModule

      unless Array.isArray(scopeNames) and isFunction(parse) and isFunction(find)
        console.error "'#{name}' should implement scopeNames, parse() and find()"
        return

      for scopeName in scopeNames
        @modules[scopeName] = module

      @emit 'changed'

  get: (sourceName) ->
    @modules[sourceName]
