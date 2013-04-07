Base = require '../lib/base'

module.exports =

  setUp: (done)->
    @base = new Base()
    done()

  '#doctype()':

    setUp: (done)->
      @doctype = '<!doctype html>'
      done()

    'it will return a HTML5 doctype when passed 5': (test)->
      html = @base.doctype 5
      test.equal html, @doctype
      test.done()

    'it will add the doctype to the #_content property': (test)->
      @base.doctype 5
      test.equal @base._content, @doctype
      test.done()

    'it will add the doctype to the beginning of the #_content property': (test)->
      @base._content = 'mung'
      @base.doctype 5
      test.equal @base._content, @doctype + 'mung'
      test.done()

  '#tag()':

    'it should return a closed tag when no content is supplied': (test)->
      html = @base.tag 'mung'
      test.equal html, '<mung/>'
      test.done()

    'if the 2nd parameter is an object, it will be turned in to HTML attributes': (test)->
      html = @base.tag 'tag', mung: 'face'
      test.equal html, '<tag mung="face"/>'
      test.done()

    'if the 2nd parameter is a string, it will be used as the tag\'s content': (test)->
      html = @base.tag 'test', 'testies'
      test.equal html, '<test>testies</test>'
      test.done()

    'the combination of object attributes and content can also be used': (test)->
      html = @base.tag 'test', {mung: 'face'}, 'testies'
      test.equal html, '<test mung="face">testies</test>'
      test.done()

    'if the content is a function, then the returned content will be used': (test)->
      html = @base.tag 'test', -> @tag 'mung'
      test.equal html, '<test><mung/></test>'
      test.done()

  '#compile()':

    'will render some functions as tags': (test)->
      result = '<html><head></head><body></body></html>'
      html = @base.compile ->
        @html ->
          @head ->
          @body ->
      test.equal @base._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

    'will use a method from it\'s own instance when a string is passed as the first argument': (test)->
      result = '<html><head></head><body></body></html>'
      class Template extends Base
        render: ->
          @html ->
            @head ->
            @body ->
      template = new Template()
      html = template.compile 'render'
      test.equal template._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

  '#script()':

    'will create a <script> tag compiling a CoffeeScript function to JavaScript': (test)->
      result = """
        <script>(function () {
                  return alert('yay');
                }).call(this)</script>
        """
      html = @base.script -> alert 'yay'
      test.equal @base._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

  '#lit()':

    'will add any content directly to the output string': (test)->
      result = '<html><body><mung/>tits, arse</body></html>'
      html = @base.compile ->
        @html ->
          @body ->
            @lit '<mung/>tits, arse'
      test.equal @base._content, result, 'it did not add the content to the #_content property'
      test.done()

