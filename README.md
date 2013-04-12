coffee-views
============

Coffee Views was inspired by [coffee-templates](https://github.com/mikesmullin/coffee-templates) and [coffeekup](https://github.com/gradus/coffeecup) to add template inheritance to CoffeeScript templating.

Installation
------------

`npm i --save coffee-views`

Example
-------

```coffee
# views/layout.coffee

{Base} = require 'coffee-views'

module.exports = class Layout extends Base
  
  # The #render() method is automatically called when rendering the view in express.
  render: (options)->
    @doctype 5
    @html ->

      @head ->
        @title options.title
        @stylesheetBlock()

      @body ->
        @h1 options.title
        @contentBlock()

  stylesheetBlock: ->
  
  contentBlock: ->
```

```coffee
# views/myview.coffee

Layout = require './layout'

module.exports = class MyView extends Layout
  contentBlock: ->
    @div ->
      @p 'This is my view'
```

```coffee
View = require './views/myview'
view = new View()

console.log view.compile 'render', title: 'My Site'
```

```html
<!doctype html>
<html>
  <head>
    <title>My Site</title>
  </head>
  <body>
    <h1>My Site</h1>
    <div>
      <p>This is my view</p>
    </div>
  </body>
</html>
```

Example 2 - in Express.js
-------------------------

```coffee
# app.coffee
# using the templates in the previous example

# ...

app = express()

app.configure ->
  app.engine 'coffee', require('coffee-views').engine
  app.set 'view engine', 'coffee'
  app.set 'views', path.join(__dirname, 'views')

# ...

app.get '/', (req, res)->
  res.render 'myview',
    title: 'My Site'
```

Inheriting methods
------------------

Just use CoffeeScript's native `super()` method to return a rendered parent method.

```coffee
class MyExtendedView extends MyView
  contentBlock: ->
    super
    @div ->
      @p 'This is an extension to "MyView"'

view = new MyExtendedView() 
console.log view.compile 'render', title: 'My extended view'
###
<!doctype html>
<html>
  <head>
    <title>My extended view</title>
  </head>
  <body>
    <h1>My extended view</h1>
    <div>
      <p>This is my view</p>
    </div>
    <div>
      <p>This is an extension to "MyView"</p>
    </div>
  </body>
</html>
###
```

Plain ol' JavaScript
--------------------

There's a possibility you may want to use plain JavaScript instead of CoffeeScript. In this case, just use Node's **util** module to extend your classes:

```javascript
// layout.js
var Base = require('coffee-views').Base,
    util = require('util');

function Layout(){}
module.exports = Layout;
util.inherits(Layout, Base);

Layout.prototype.render = function(options){
  this.doctype(5);
  this.head(function(){
    this.title(options.title);
    this.stylesheetBlock();
  });
  this.body(function(){
    this.h1(options.title);
    this.contentBlock();
  });
};

Layout.prototype.stylesheetBlock = function(){};
Layout.prototype.contentBlock = function(){};
```

```javascript
// myview.js
var Layout = require('./layout'),
    util = require('util');

function MyExtendedView(){}
module.exports = MyExtendedView;
util.inherits(MyExtendedView, Layout);

MyView.prototype.contentBlock = function(){
  this.div(function(){
    this.p('My content');
  });
};
```

```javascript
// extendedview.js
var MyView = require('./myview'),
    util = require('util');

function ExtendedView(){}
module.exports = ExtendedView;
util.inherits(ExtendedView, MyView);

ExtendedView.prototype.contentBlock = function(){
  ExtendedView.super_.prototype.contentBlock.call(this);
  this.div(function(){
    this.p('Native extensions');
  });
};
```

Extra Tags
----------

### The JavaScript Tag

Using the `#javascript()` function will create a `<script>` tag with the passed function as a string.

```coffee
class MyView extends Base
  javascriptBlock: ->
    @javascript ->
      alert 'Yay! CoffeeScript'

view = new MyView()
console.log view.compile 'javascriptBlock'
###
<script>(function () {
          alert('Yay! CoffeeScript!');
        }).call(this)</script>
###
```

### CSS

The `#css()` method renders as [CCSS](https://github.com/aeosynth/ccss). Pass an object and it will create a `<style>` tag.

```coffee
class MyView extends Base
  stylesheetBlock: ->
    @css
      form:
        input:
          padding: '5px'
          border: '1px solid'

view = new MyView()
console.log view.compile 'stylesheetBlock'
###
<style>form input {
  padding: 5px;
  border: 1px solid;
}
</style>
###
```

### The Literal Tag

Using the `#lit()` method will just add any content to the output string:

```coffee
class MyView extends Base
  contentBlock: ->
    @lit '<wierdtag/> Mung'

view = new MyView()
console.log view.compile 'contentBlock'
###
<wierdtag/> Mung
###
```

### The Unliteral Tag

Using the `#unlit()` method will escape content *if* **#safeOutput** is set to **true** (which it is by default).

```coffee
class MyView extends Base
  contentBlock: ->
    @unlit '<wierdtag/> Mung'

view = new MyView()
console.log view.compile 'contentBlock'
###
&lt;wierdtag/&gt; Mung
###
```

### Escaping content on the fly

If you want to make sure something is escaped, go ahead and use the #escape() method:

```coffee
escapedContent = @escape '<mung>' # => '&lt;mung&gt;'
```

