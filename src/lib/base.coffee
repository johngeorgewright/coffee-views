regExpHelper = require './regexp'

module.exports = class Base

  constructor: ->
    @_content = ''
    @safeOutput = yes
    @specialChars = {}

  compile: (fn)->
    @_content = ''
    args = Array::slice.call arguments, 1
    if typeof(fn) is 'string'
      throw new TypeError "Method #{@constructor.name}.#{options.method} does not exist" unless typeof(@[fn]) is 'function'
      fn = @[fn]
    fn.apply this, args
    @_content

  partial: (path, options={})->
    options.method ?= 'render'
    options.data ?= {}
    View = require path
    view = new View()
    @lit view.compile options.method, options.data

  lit: (output)->
    @_content += output
    output

  unlit: (output)->
    output = if @safeOutput then @escape output else output
    @lit output

  escape: (str)->
    keys = Object.keys @specialChars
    keys = (regExpHelper.escape key for key in keys)
    keys = keys.join ''
    regExp = new RegExp "[#{keys}]", 'g'
    str.toString().replace regExp, (char)=> @specialChars[char] or char

