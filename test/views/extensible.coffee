WithParameters = require './with-parameters'

module.exports = class Extensible extends WithParameters
  head: ->
    title @title
    meta encoding: 'utf8'

