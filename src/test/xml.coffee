Xml = require '../lib/xml'

module.exports =

  setUp: (done)->
    @xml = new Xml()
    done()

  '#comment()':

    'it will display a HTML comment': (test)->
      html = @xml.comment 'This is a comment'
      test.equal html, '<!-- This is a comment -->'
      test.done()

  '#escape()':

    'it should escape all HTML characters': (test)->
      html = @xml.escape '<mungface>\'Milk\' & "honey"</mungface>'
      test.equal html, '&lt;mungface&gt;&#39;Milk&#39; &amp; &quot;honey&quot;&lt;/mungface&gt;'
      test.done()

  '#tag()':

    'it should return a closed tag when no content is supplied': (test)->
      html = @xml.tag 'mung'
      test.equal html, '<mung/>'
      test.done()

    'if the 2nd parameter is an object, it will be turned in to HTML attributes': (test)->
      html = @xml.tag 'tag', mung: 'face'
      test.equal html, '<tag mung="face"/>'
      test.done()

    'if the 2nd parameter is a string, it will be used as the tag\'s content': (test)->
      html = @xml.tag 'test', 'testies'
      test.equal html, '<test>testies</test>'
      test.done()

    'the combination of object attributes and content can also be used': (test)->
      html = @xml.tag 'test', {mung: 'face'}, 'testies'
      test.equal html, '<test mung="face">testies</test>'
      test.done()

    'if the content is a function, then the returned content will be used': (test)->
      html = @xml.tag 'test', -> @tag 'mung'
      test.equal html, '<test><mung/></test>'
      test.done()

    'if an array is passed as an attribute value, it will be joined with spaces': (test)->
      html = @xml.tag 'test', {brungle:['mung', 'face']}
      test.equal html, '<test brungle="mung face"/>'
      test.done()

  '#compile()':

    'will render some functions as tags': (test)->
      result = '<html><head></head><body></body></html>'
      html = @xml.compile ->
        @tag 'html', ->
          @tag 'head', ->
          @tag 'body', ->
      test.equal @xml._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

    'will use a method from it\'s own instance when a string is passed as the first argument': (test)->
      result = '<html><head></head><body></body></html>'
      class Template extends Xml
        render: ->
          @tag 'html', ->
            @tag 'head', ->
            @tag 'body', ->
      template = new Template()
      html = template.compile 'render'
      test.equal template._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

  '#lit()':

    'will add any content directly to the output string': (test)->
      result = '<html><body><mung/>tits, arse</body></html>'
      html = @xml.compile ->
        @tag 'html', ->
          @tag 'body', ->
            @lit '<mung/>tits, arse'
      test.equal @xml._content, result, 'it did not add the content to the #_content property'
      test.done()

  '#unlit()':

    'will escape HTML when the #safeOutput is true': (test)->
      @xml.safeOutput = yes
      html = @xml.unlit '<unlit>'
      test.equal html, '&lt;unlit&gt;'
      test.done()

    'will just display a literal value when #safeOutput is false': (test)->
      @xml.safeOutput = no
      html = @xml.unlit '<unlit>'
      test.equal html, '<unlit>'
      test.done()

