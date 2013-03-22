WithParameters = require './with-parameters'

module.exports = class Extensible extends WithParameters
  head: ->
    literal parent 'head'
    meta encoding: 'utf8'

