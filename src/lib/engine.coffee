CoffeeTemplate = require 'coffee-templates'
engine         = new CoffeeTemplate()

module.exports = (path, options, callback)->
  Template = require path
  template = new Template options
  html     = template.render()

  callback null, html

