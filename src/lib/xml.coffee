regExpHelper = require './regexp'
util = require './util'

module.exports = class Xml

  constructor: ->
    @_content = ''
    @safeOutput = yes
    @specialChars =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      "'": '&#39;'

  doctype: (content)->
    doctype = "<!DOCTYPE #{content}>"
    @_content = doctype + @_content
    doctype

  comment: (content='')->
    "<!-- #{util.contentCreator.call this, content} -->"

  compile: (fn)->
    @_content = ''
    args = Array::slice.call arguments, 1
    fn = @[fn] if typeof(fn) is 'string'
    fn.apply this, args
    @_content

  lit: (output)->
    @_content += output
    output

  unlit: (output)->
    output = if @safeOutput then @escape output else output
    @lit output

  escape: (str)->
    keys = Object.keys @specialChars
    keys = (regExpHelper.escape key for key in keys)
    keys = keys.join ''
    regExp = new RegExp "[#{keys}]", 'g'
    str.toString().replace regExp, (char)=> @specialChars[char] or char

  tag: (name, attrs={}, content=false)->
    unless typeof(attrs) is 'object'
      content = attrs
      attrs = {}

    html = "<#{name}"

    for own key, val of attrs
      if val
        html += ' ' + key
        unless typeof(val) is 'boolean'
          val = val.join ' ' if val instanceof Array
          html += "=\"#{if @safeOutput then @escape val else val}\""

    content = util.contentCreator.call this, content

    if content is false
      html += '/>'
    else
      html += ">#{content}</#{name}>"

    @_content += html
    html

