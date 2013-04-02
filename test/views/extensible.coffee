WithParameters = require './with-parameters'

module.exports = class Extensible extends WithParameters
  head: ->
    literal parent()
    meta encoding: 'utf8'

