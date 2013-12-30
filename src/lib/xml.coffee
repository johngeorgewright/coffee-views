Base = require './base'
regExpHelper = require './regexp'
util = require './util'

module.exports = class Xml extends Base

  constructor: ->
    Base.apply this, arguments
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

  @registerTag: (tag, alterArgs)->
    @::[tag] = ->
      args = Array::slice.call arguments
      alterArgs args if typeof(alterArgs) is 'function'
      args.unshift tag
      @tag.apply this, args

  @registerOpenTag: (tag)->
    @registerTag tag, (args)->
      if args.length < 2 and typeof(args[0]) not in ['string', 'function']
        args.push ''

  @registerClosedTag: (tag)->
    @registerTag tag, (args)->
      last = args.length - 1
      if last >= 0 and typeof(args[last]) isnt 'object'
        args[last] = false

