Base = require '../../lib/base'

module.exports = class WithParameters extends Base
  render: ->
    doctype 5
    html ->
      head ->
        @head()
      body ->
        h1 @title

  head: ->
    title @title

