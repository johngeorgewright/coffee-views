Renderer = require '../lib/renderer'

module.exports =

  setUp: (done)->
    @renderer = new Renderer()
    done()

  '#doctype()':

    setUp: (done)->
      @doctype = '<!doctype html>'
      done()

    'it will return a HTML5 doctype when passed 5': (test)->
      html = @renderer.doctype 5
      test.equal html, @doctype
      test.done()

    'it will add the doctype to the #_content property': (test)->
      @renderer.doctype 5
      test.equal @renderer._content, @doctype
      test.done()

    'it will add the doctype to the beginning of the #_content property': (test)->
      @renderer._content = 'mung'
      @renderer.doctype 5
      test.equal @renderer._content, @doctype + 'mung'
      test.done()

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

  '#compile()':

    'will render some functions as tags': (test)->
      result = '<html><head></head><body></body></html>'
      html = @renderer.compile ->
        @html ->
          @head ->
          @body ->
      test.equal @renderer._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

    'will use a method from it\'s own instance when a string is passed as the first argument': (test)->
      result = '<html><head></head><body></body></html>'
      class Template extends Renderer
        render: ->
          @html ->
            @head ->
            @body ->
      template = new Template()
      html = template.compile 'render'
      test.equal template._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

