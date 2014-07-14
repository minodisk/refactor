{ resolve, dirname, basename, extname, relative, join } = require 'path'
{ readdirSync, statSync } = require 'fs'

findModules = (dir = __dirname) ->
  coffeeFiles = []
  files = readdirSync dir
  for file in files
    file = resolve dir, file
    continue if file is __filename
    stat = statSync file
    if stat.isDirectory()
      coffeeFiles = coffeeFiles.concat findModules file
      continue
    if extname(file) in [ '.coffee', '.js' ]
      coffeeFiles.push relative __dirname, file
  coffeeFiles

for module in findModules()
  namespace = dirname module
  name = basename module, extname module
  exp = exports
  if namespace isnt '.'
    exp = exports
    for ns in namespace.split '/'
      exp[ns] ?= {}
      exp = exp[ns]
  exp[name] = require "./#{module}"
