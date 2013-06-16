ccss = require 'ccss'
util = require './util'
Xml = require './xml'

module.exports = class Html extends Xml

  constructor: ->
    Xml.apply this, arguments
    @doctypes = 5: '<!doctype html>'

  doctype: (version=5)->
    throw new ReferenceError "Doctype verision \"#{version}\" does not exist" unless @doctypes[version]?
    doctype = @doctypes[version]
    @_content = doctype + @_content
    doctype

  css: (attrs, content={})->
    if arguments.length < 2
      content = attrs
      attrs = {}
    css = ccss.compile content
    safeOutput = @safeOutput
    tag = @style attrs, css
    @safeOutput = safeOutput
    tag

  ie: (version=null, content='')->
    if arguments.length < 2
      content = version
      version = ''
    else
      version = ' ' + version
    "<!--[if IE#{version}]>#{util.contentCreator.call this, content}<[endif]-->"

  javascript: (attrs={}, args=[], content='')->
    if attrs instanceof Array
      content = args
      args = attrs
      attrs = {}
    else if typeof(attrs) is 'function'
      content = attrs
      args = []
      attrs = {}
    unless args instanceof Array
      content = args
      args = []
    if typeof(content) is 'function'
      content = "(#{content})"
      if args.length > 0
        for arg, i in args
          switch typeof arg
            when 'string' then args[i] = "\"#{arg}\""
            when 'function' then args[i] = arg.toString()
            when 'object' then args[i] = JSON.stringify arg
        content += ".call(this, #{args.join ', '})"
      else
        content += '.call(this)'
    safeOutput = @safeOutput
    @safeOutput = no
    tag = @script attrs, content
    @safeOutput = safeOutput
    tag

  openTags = 'a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup command data datagrid datalist dd del details dfn div dl dt em embed eventsource fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup html i iframe ins kbd keygen label legend li mark map menu meter nav noscript object ol optgroup option output p pre progress q ruby rp rt s samp script section select small source span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr'.split ' '
  for tag in openTags
    do (tag)->
      Html::[tag] = ->
        args = Array::slice.call arguments
        if args.length < 2 and typeof(args[0]) not in ['string', 'function']
          args.push ''
        args.unshift tag
        @tag.apply this, args

  closedTags = 'area base br col hr img input link meta param'.split ' '
  for tag in closedTags
    do (tag)->
      Html::[tag] = ->
        args = Array::slice.call arguments
        args[1] = false
        args.unshift tag
        @tag.apply this, args

