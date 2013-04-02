CoffeeTemplate = require 'coffee-templates'
_              = require 'underscore'

# A class used only for modifying a template's
# global functions.
class TemplateGlobals
  # The constructor takes a prototype of the
  # coffee view object.
  constructor: (coffeeView)->
    proto = coffeeView.constructor
    @[proto.name] = proto

# Re-writes all methods of an object so that
# the methods will compile a template.
# @param proto {Object} The view's prototype
# @param ins {Object} The context which you want to bind the functions to
bind = (proto)->
  sup = proto.constructor.__super__ ? proto.constructor.super_
  # Loop through every method in the proto
  for method in _(proto).methods()
    # Unless the method is the constructor or
    # has already been bound...
    unless method is 'constructor' or proto[method]._cvBound
      do (proto, method)->
        # The original method
        fn = proto[method]
        # Re-write the method
        proto[method] = ->
          # Extra template globals
          globals = new TemplateGlobals proto
          # Create a new template renderer
          template = new CoffeeTemplate globals: globals
          # Render the template
          template.render fn, this
      # Add a property to the new method that
      # can be used to prevent binding the
      # same method more than once.
      proto[method]._cvBound = true
  bind sup if sup

module.exports = class Base
  constructor: (options)->
    bind this
    for own key, value of options
      @[key] = value unless @[key]?

  render: ->
    throw new Error 'You need to override the render method'

