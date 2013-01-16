CoffeeTemplate = require 'coffee-templates'
_              = require 'underscore'

module.exports = class Base
  constructor: (options)->
    for own key, value of options
      @[key] = value unless @[key]?

    _(@).methods().forEach (method)=>
      template  = new CoffeeTemplate()
      fn        = @[method]
      @[method] = => template.render fn, this

  render: ->
    throw new Error 'You need to override the render method'

