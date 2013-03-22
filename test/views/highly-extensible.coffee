Extensible = require './extensible'

module.exports = class HighlyExtensible extends Extensible
  head: ->
    throw new Error "YEH"
    literal parent 'head'
    meta name: 'description', content: 'A description'

