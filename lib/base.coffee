CoffeeTemplate = require 'coffee-templates'
_              = require 'underscore'

class TemplateGlobals
  constructor: (@proto)->

  parent: (method)->
    args = Array::slice.call arguments, 1
    method = @proto.constructor.__super__[method]
    method.apply @proto, args

# Re-writes all methods of an object so that
# the methods will compile a template.
bind = (proto, ins)->
  ins ?= proto
  # Loop through every method in the proto
  for method in _(proto).methods()
    # Unless the method is the constructor or
    # has already been bound...
    unless method is 'constructor' or proto[method].cvBound
      globals = new TemplateGlobals proto
      # Create a new template renderer
      template = new CoffeeTemplate globals: globals
      # The method
      fn = proto[method]
      # Re-write the method
      proto[method] = -> template.render fn, ins
      # Add a property to the new method that
      # can be used to prevent binding the
      # same method more than once.
      proto[method].cvBound = yes
  # Bind the super's prototype if a super exists
  sup = proto.constructor.__super__
  bind sup, ins if sup

module.exports = class Base
  constructor: (options)->
    bind this
    for own key, value of options
      @[key] = value unless @[key]?

  render: ->
    throw new Error 'You need to override the render method'

