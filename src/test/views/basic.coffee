Base = require '../../lib/base'

module.exports = class BasicTemplate extends Base
  render: ->
    @doctype 5
    @html ->
      @head ->
      @body ->

