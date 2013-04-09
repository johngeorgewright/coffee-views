module.exports = class Base

  constructor: ->
    @_content = ''
    @doctypes = 5: '<!doctype html>'

  doctype: (version=5)->
    throw new ReferenceError "Doctype verision \"#{version}\" does not exist" unless @doctypes[version]?
    doctype = @doctypes[version]
    @_content = doctype + @_content
    doctype

  script: (attrs={}, fn='')->
    if typeof(attrs) is 'function'
      fn = attrs
      attrs = {}
    @tag 'script', attrs, "(#{fn}).call(this)"

  compile: (fn)->
    @_content = ''
    args = Array::slice.call arguments, 1
    fn = @[fn] if typeof(fn) is 'string'
    fn.apply this, args
    @_content

  lit: (output)->
    @_content += output
    output

  tag: (name, attrs={}, content=false)->
    unless typeof(attrs) is 'object'
      content = attrs
      attrs = {}

    html = "<#{name}"

    for own key, val of attrs
      if val
        html += ' ' + key
        unless typeof(val) is 'boolean'
          html += "=\"#{val}\""

    if typeof(content) is 'function'
      renderer = new @constructor()
      content = renderer.compile content

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

