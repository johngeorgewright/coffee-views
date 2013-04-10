regExpHelper = require './regexp'

module.exports = class Base

  constructor: ->
    @_content = ''
    @doctypes = 5: '<!doctype html>'
    @safeOutput = yes
    @specialChars =
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      "'": '&#39;'

  doctype: (version=5)->
    throw new ReferenceError "Doctype verision \"#{version}\" does not exist" unless @doctypes[version]?
    doctype = @doctypes[version]
    @_content = doctype + @_content
    doctype

  script: (attrs={}, args=[], content='')->
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
    tag = @tag 'script', attrs, content
    @safeOutput = safeOutput
    tag

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
    str.replace regExp, (char)=> @specialChars[char] or char

  tag: (name, attrs={}, content=false)->
    unless typeof(attrs) is 'object'
      content = attrs
      attrs = {}

    html = "<#{name}"

    for own key, val of attrs
      if val
        html += ' ' + key
        unless typeof(val) is 'boolean'
          html += "=\"#{if @safeOutput then @escape val else val}\""

    if typeof(content) is 'function'
      renderer = new @constructor()
      content = renderer.compile content
    else if typeof(content) is 'string' and @safeOutput
      content = @escape content

    if content is false
      html += '/>'
    else
      html += ">#{content}</#{name}>"

    @_content += html
    html

  openTags = 'a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup command data datagrid datalist dd del details dfn div dl dt em embed eventsource fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup html i iframe ins kbd keygen label legend li mark map menu meter nav noscript object ol optgroup option output p pre progress q ruby rp rt s samp section select small source span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr'.split ' '
  for tag in openTags
    do (tag)->
      Base::[tag] = ->
        args = Array::slice.call arguments
        if args.length < 2 and typeof(args[0]) not in ['string', 'function']
          args.push ''
        args.unshift tag
        @tag.apply this, args

  closedTags = 'area base br col hr img input link meta param'.split ' '
  for tag in closedTags
    do (tag)->
      Base::[tag] = ->
        args = Array::slice.call arguments
        args[1] = false
        args.unshift tag
        @tag.apply this, args

  render: ->
    throw new Error 'You need to override the render method'

