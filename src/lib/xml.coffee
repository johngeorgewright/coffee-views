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

  @registerTag: (tag) ->
    @::[tag] = ->
      args = Array::slice.call arguments
      args.unshift tag
      @tag.apply this, args

  @registerOpenTag: (tag) ->
    @::[tag] = ->
      args = Array::slice.call arguments
      if args.length < 2 and typeof(args[0]) not in ['string', 'function']
        args.push ''
      args.unshift tag
      @tag.apply this, args

  @registerClosedTag: (tag) ->
    @::[tag] = ->
      args = Array::slice.call arguments
      last = args.length - 1
      if args.length > 0 and typeof(args[last]) isnt 'object'
        args[last] = false
      args.unshift tag
      @tag.apply this, args

