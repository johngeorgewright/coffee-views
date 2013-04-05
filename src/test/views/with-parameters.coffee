Base = require '../../lib/base'

module.exports = class WithParameters extends Base
  render: (options)->
    @doctype 5
    @html ->
      @head ->
        @headBlock options.title
      @body ->
        @h1 options.title

  headBlock: (title)->
    @title title

