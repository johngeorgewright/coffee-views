CoffeeTemplate = require 'coffee-templates'
_              = require 'underscore'

# A class used only for modifying a template's
# global functions.
class TemplateGlobals
  # The constructor takes a prototype of the
  # coffee view object.
  # @param proto {Object} The coffee view object prototype
  constructor: (@_cvProto, @_cvMethodName, ins)->
    # The instance default is the prototype
    @_cvContext = ins ? @_cvProto

  # The parent method is added a global function
  # that will call the view's super method.
  # @param method {String} The super's method name
  # @return mixed
  parent: ->
    # The super prototype
    sup = @_cvProto.constructor.__super__
    # Find the parent method
    method = sup[@_cvMethodName]
    # Extra template globals
    globals = new TemplateGlobals sup, @_cvMethodName, @_cvContext
    # Create a new template renderer
    renderer = new CoffeeTemplate globals: globals
    # Render the template
    renderer.render method, @_cvContext

# Re-writes all methods of an object so that
# the methods will compile a template.
# @param proto {Object} The view's prototype
# @param ins {Object} The context which you want to bind the functions to
bind = (proto)->
  # Loop through every method in the proto
  for method in _(proto).methods()
    # Unless the method is the constructor or
    # has already been bound...
    unless method is 'constructor'
      do (proto, method)->
        # The original method
        fn = proto[method]
        # Re-write the method
        proto[method] = ->
          # Extra template globals
          globals = new TemplateGlobals proto, method
          # Create a new template renderer
          template = new CoffeeTemplate globals: globals
          # Render the template
          template.render fn, proto

module.exports = class Base
  constructor: (options)->
    bind this
    for own key, value of options
      @[key] = value unless @[key]?

  render: ->
    throw new Error 'You need to override the render method'

