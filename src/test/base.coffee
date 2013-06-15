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

  '#comment()':

    'it will display a HTML comment': (test)->
      html = @base.comment 'This is a comment'
      test.equal html, '<!-- This is a comment -->'
      test.done()

  '#ie()':

    'it will create an IE conditional comment': (test)->
      html = @base.ie 'IE only'
      test.equal html, '<!--[if IE]>IE only<[endif]-->'
      test.done()

    'it can specify a version': (test)->
      html = @base.ie 6, 'IE 6 only'
      test.equal html, '<!--[if IE 6]>IE 6 only<[endif]-->'
      test.done()

  '#escape()':

    'it should escape all HTML characters': (test)->
      html = @base.escape '<mungface>\'Milk\' & "honey"</mungface>'
      test.equal html, '&lt;mungface&gt;&#39;Milk&#39; &amp; &quot;honey&quot;&lt;/mungface&gt;'
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

    'if an array is passed as an attribute value, it will be joined with spaces': (test)->
      html = @base.tag 'test', {brungle:['mung', 'face']}
      test.equal html, '<test brungle="mung face"/>'
      test.done()

  '#[tag]()':

    'certain tags will be made open by default': (test)->
      html = @base.i()
      test.equal html, '<i></i>'
      html = @base.i class:'icon-thumb'
      test.equal html, '<i class="icon-thumb"></i>'
      test.done()

    'certain tags will be made closed by default': (test)->
      html = @base.meta {name:'mung', content:'face'}, 'Mung Face'
      test.equal html, '<meta name="mung" content="face"/>'
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

  '#javascript()':

    'will create a <script> tag compiling a CoffeeScript function to JavaScript': (test)->
      result = """
        <script>(function () {
                  return alert('yay');
                }).call(this)</script>
        """
      html = @base.javascript -> alert 'yay'
      test.equal @base._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

    'it can have server variables passed as arguments': (test)->
      result = """
        <script>(function (name, details, fn) {
                  return fn(alert("Hey! " + name + " you live in " + details.area));
                }).call(this, "mung", {"area":"Newbury"}, function () {
                  return alert('Hurrah!');
                })</script>
        """
      serverVar1 = 'mung'
      serverVar2 = area: 'Newbury'
      serverVar3 = -> alert 'Hurrah!'
      html = @base.javascript [serverVar1, serverVar2, serverVar3], (name, details, fn)->
        fn alert "Hey! #{name} you live in #{details.area}"
      test.equal html, result
      test.done()

    'it can have attributes just like any other tag': (test)->
      result = """
        <script async>(function (name, details, fn) {
                  return fn(alert("Hey! " + name + " you live in " + details.area));
                }).call(this, "mung", {"area":"Newbury"}, function () {
                  return alert('Hurrah!');
                })</script>
        """
      serverVar1 = 'mung'
      serverVar2 = area: 'Newbury'
      serverVar3 = -> alert 'Hurrah!'
      html = @base.javascript {async:yes}, [serverVar1, serverVar2, serverVar3], (name, details, fn)->
        fn alert "Hey! #{name} you live in #{details.area}"
      test.equal html, result
      result = """
        <script async>(function () {
                  return alert('Hurray!');
                }).call(this)</script>
        """
      html = @base.javascript {async:yes}, ->
        alert 'Hurray!'
      test.equal html, result
      test.done()

  '#css()':

    'it will render content as CCSS': (test)->
      result = """
        <style>form input {
          padding: 5px;
        }
        </style>
        """
      css = @base.css
        form:
          input:
            padding: '5px'
      test.equal css, result
      test.done()

    'it can take attributes like any other tag': (test)->
      result = """
        <style id="mung">form input {
          padding: 5px;
        }
        </style>
        """
      css = @base.css {id:'mung'},
        form:
          input:
            padding: '5px'
      test.equal css, result
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

  '#unlit()':

    'will escape HTML when the #safeOutput is true': (test)->
      @base.safeOutput = yes
      html = @base.unlit '<unlit>'
      test.equal html, '&lt;unlit&gt;'
      test.done()

    'will just display a literal value when #safeOutput is false': (test)->
      @base.safeOutput = no
      html = @base.unlit '<unlit>'
      test.equal html, '<unlit>'
      test.done()

