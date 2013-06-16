Html = require '../../lib/html'

module.exports = class WithParameters extends Html
  render: (options)->
    @doctype 5
    @html ->
      @head ->
        @headBlock options.title
      @body ->
        @h1 options.title

  headBlock: (title)->
    @title title

