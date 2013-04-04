module.exports = class Renderer

  render: (fn)->
    @_content = ''
    fn.call this
    @_content

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
      renderer = new Renderer()
      content = renderer.render content

    if content is false
      html += '/>'
    else
      html += ">#{content}</#{name}>"

    @_content = html

  tags = 'a abbr address area article aside audio b base bdi bdo blockquote body br button canvas caption cite code col colgroup command data datagrid datalist dd del details dfn div dl dt em embed eventsource fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img ins input kbd keygen label legend li link mark map menu meta meter nav noscript object ol optgroup option output p param pre progress q ruby rp rt s samp script section select small source span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr'.split ' '

  for tag in tags
    do (tag)->
      Renderer::[tag] = ->
        args = Array::slice.call arguments
        args.unshift tag
        @tag.apply this, args

