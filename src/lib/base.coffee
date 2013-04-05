Renderer = require './renderer'

module.exports = class Base extends Renderer
  constructor: (options)->
    super()
    renderMethod = @render
    @render = (options)-> @compile renderMethod, options

  render: ->
    throw new Error 'You need to override the render method'

