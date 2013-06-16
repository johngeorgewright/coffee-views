exports.contentCreator = (content)->
  if typeof(content) is 'function'
    renderer = new @constructor()
    content = renderer.compile content
  else if typeof(content) is 'string' and @safeOutput
    content = @escape content
  content

