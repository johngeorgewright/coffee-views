WithParameters = require './with-parameters'

module.exports = class Extensible extends WithParameters
  head: ->
    literal super()
    meta encoding: 'utf8'

