Extensible = require './extensible'

module.exports = class HighlyExtensible extends Extensible
  head: ->
    literal parent()
    meta name: 'description', content: 'A description'

