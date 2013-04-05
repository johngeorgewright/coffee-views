Renderer = require './renderer'

module.exports = class Base extends Renderer
  render: ->
    throw new Error 'You need to override the render method'

