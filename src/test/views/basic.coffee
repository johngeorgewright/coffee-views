Html = require '../../lib/html'

module.exports = class BasicTemplate extends Html
  render: ->
    @doctype 5
    @html ->
      @head ->
      @body ->

