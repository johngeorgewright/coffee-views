Base = require './base'

module.exports = (path, options, callback)->
  Template = require path
  template = new Template()
  throw new Error 'The template class is not an instance of coffee-views.Base' unless template instanceof Base
  html = template.compile 'render', options
  callback null, html

