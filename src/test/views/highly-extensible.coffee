Extensible = require './extensible'

module.exports = class HighlyExtensible extends Extensible
  head: ->
    literal super()
    meta name: 'description', content: 'A description'

