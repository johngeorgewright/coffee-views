WithParameters = require './with-parameters'

module.exports = class Extensible extends WithParameters
  headBlock: ->
    super
    @meta encoding:'utf8'

