Renderer = require '../lib/renderer'

module.exports =

  setUp: (done)->
    @renderer = new Renderer()
    done()

  '#tag()':

    'it should return a closed tag when no content is supplied': (test)->
      html = @renderer.tag 'mung'
      test.equal html, '<mung/>'
      test.done()

    'if the 2nd parameter is an object, it will be turned in to HTML attributes': (test)->
      html = @renderer.tag 'tag', mung: 'face'
      test.equal html, '<tag mung="face"/>'
      test.done()

    'if the 2nd parameter is a string, it will be used as the tag\'s content': (test)->
      html = @renderer.tag 'test', 'testies'
      test.equal html, '<test>testies</test>'
      test.done()

    'the combination of object attributes and content can also be used': (test)->
      html = @renderer.tag 'test', {mung: 'face'}, 'testies'
      test.equal html, '<test mung="face">testies</test>'
      test.done()

    'if the content is a function, then the returned content will be used': (test)->
      html = @renderer.tag 'test', -> @tag 'mung'
      test.equal html, '<test><mung/></test>'
      test.done()

  '#render()':

    'will render some functions as tags': (test)->
      html = @renderer.render ->
        @html ->
          @head ->
          @body ->
      test.equal html, '<html><head></head><body></body></html>'
      test.done()

