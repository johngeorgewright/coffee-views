Html = require '../lib/html'

module.exports =

  setUp: (done)->
    @html = new Html()
    done()

  '#doctype()':

    setUp: (done)->
      @doctype = '<!doctype html>'
      done()

    'it will return a HTML5 doctype when passed 5': (test)->
      html = @html.doctype 5
      test.equal html, @doctype
      test.done()

    'it will add the doctype to the #_content property': (test)->
      @html.doctype 5
      test.equal @html._content, @doctype
      test.done()

    'it will add the doctype to the beginning of the #_content property': (test)->
      @html._content = 'mung'
      @html.doctype 5
      test.equal @html._content, @doctype + 'mung'
      test.done()

  '#ie()':

    'it will create an IE conditional comment': (test)->
      html = @html.ie 'IE only'
      test.equal html, '<!--[if IE]>IE only<[endif]-->'
      test.done()

    'it can specify a version': (test)->
      html = @html.ie 6, 'IE 6 only'
      test.equal html, '<!--[if IE 6]>IE 6 only<[endif]-->'
      test.done()

  '#[tag]()':

    'certain tags will be made open by default': (test)->
      html = @html.i()
      test.equal html, '<i></i>'
      html = @html.i class:'icon-thumb'
      test.equal html, '<i class="icon-thumb"></i>'
      test.done()

    'certain tags will be made closed by default': (test)->
      html = @html.meta {name:'mung', content:'face'}, 'Mung Face'
      test.equal html, '<meta name="mung" content="face"/>'
      test.done()

  '#javascript()':

    'will create a <script> tag compiling a CoffeeScript function to JavaScript': (test)->
      result = """
        <script>(function () {
                  return alert('yay');
                }).call(this)</script>
        """
      html = @html.javascript -> alert 'yay'
      test.equal @html._content, result, 'it did not add the content to the #_content property'
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
      html = @html.javascript [serverVar1, serverVar2, serverVar3], (name, details, fn)->
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
      html = @html.javascript {async:yes}, [serverVar1, serverVar2, serverVar3], (name, details, fn)->
        fn alert "Hey! #{name} you live in #{details.area}"
      test.equal html, result
      result = """
        <script async>(function () {
                  return alert('Hurray!');
                }).call(this)</script>
        """
      html = @html.javascript {async:yes}, ->
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
      css = @html.css
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
      css = @html.css {id:'mung'},
        form:
          input:
            padding: '5px'
      test.equal css, result
      test.done()

