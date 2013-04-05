module.exports = (path, options, callback)->
  Template = require path
  template = new Template()
  html     = template.render options

  callback null, html

