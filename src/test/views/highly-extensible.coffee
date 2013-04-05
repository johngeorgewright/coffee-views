Extensible = require './extensible'

module.exports = class HighlyExtensible extends Extensible
  headBlock: ->
    super
    @meta name:'description', content:'A description'

