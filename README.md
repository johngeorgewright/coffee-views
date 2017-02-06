coffee-views
============

[![Greenkeeper badge](https://badges.greenkeeper.io/johngeorgewright/coffee-views.svg)](https://greenkeeper.io/)

Coffee Views was inspired by [coffee-templates](https://github.com/mikesmullin/coffee-templates) and [coffeekup](https://github.com/gradus/coffeecup) to add template inheritance to CoffeeScript templating.

Installation
------------

`npm i --save coffee-views`

Example
-------

```coffee
# views/layout.coffee

{Html} = require 'coffee-views'

module.exports = class Layout extends Html
  
  # The #render() method is automatically called when rendering the view in express.
  render: (options)->
    @doctype 5
    @html {lang:'en'}, ->

      @head ->
        @title options.title
        @stylesheetBlock()

      @body ->
        @h1 options.title
        @contentBlock()

  stylesheetBlock: ->
    @link rel:'stylesheet', href:'/css/main.css'
  
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

... will produce ...

```html
<!doctype html>
<html lang="en">
  <head>
    <title>My Site</title>
    <link rel="stylesheet" href="/css/main.css"/>
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
var Html = require('coffee-views').Html,
    util = require('util');

function Layout(){}
module.exports = Layout;
util.inherits(Layout, Html);

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

Registering XML Tags
--------------------

When creating your own XML tags you can register them like so:

```coffee
# my-xml.coffee

{Xml} = require 'coffee-views'

class MyXml extends Xml
  
MyXml.registerTag 'mung'
MyXml.registerTag 'face'
MyXml.registerOpenTag 'this-is-always-open'
MyXml.registerClosedTag 'this-is-always-closed'
```

```coffee
# your-xml.coffee

MyXml = require './my-xml'

class YourXml extends MyXml
  render: ->
    @mung ->
      @face 'yay, custom tags'
    @['this-is-always-open']()
    @['this-is-always-closed']()

# <mung><face>yay custom tags</face></mung>
# <this-is-always-open></this-is-always-open>
# <this-is-always-closed/>
```

Registered HTML Tags
--------------------

Apart from the obvious HTML5 compliant tags, here are a few extras.

### The JavaScript Tag

Using the `#javascript()` function will create a `<script>` tag with the passed function as a string.

```coffee
class MyView extends Html
  javascriptBlock: ->
    @javascript ->
      alert 'Yay! CoffeeScript'

view = new MyView()
console.log view.compile 'javascriptBlock'
###
<script>
(function () {
  alert('Yay! CoffeeScript!');
}).call(this)
</script>
###
```

You can also pass server variables through to your client code:

```coffee
class MyView extends Html
  javascriptBlock: (options)->

    # Assuming "options" is {username:'Craig David'}

    @javascript [options.username], (username)->
      alert "Your name is #{username}. Lucky you. *snigger*"

    @javascript [options], (options)->
      alert "Name: #{options.name}"

    @javascript [-> 'Craig David'], (getName)->
      alert "getting name... #{getName()}"
```
... will produce ...
```html
<script>
(function(username){
  alert('Your name is ' + username + '. Lucky you. *snigger*');
}).call(this, 'Craig David')
</script>

<script>
(function(options){
  alert('Name: ' + options.name);
}).call(this, {username:'Craig David'});
</script>

<script>
(function(getName){
  alert('getting name... ' + getName());
}).call(this, function(){ return 'Craig David'; })
</script>
```

### CSS

The `#css()` method renders as [CCSS](https://github.com/aeosynth/ccss). Pass an object and it will create a `<style>` tag.

```coffee
class MyView extends Html
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
class MyView extends Html
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
class MyView extends Html
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

### Comments

HTML comments.

```coffee
@comment 'Here\'a a comment'
@comment ->
  @p 'I\'ve been a commented out'
```

### IE Specific comments

```coffee
@ie ->
  @link rel:'stylesheet', href:'ie.css'
@ie 7, ->
  @link rel:'stylesheet', href:'ie7.css'
@ie 'lte', 8, ->
  @link rel:'stylesheet', href:'ie8.css'
```

