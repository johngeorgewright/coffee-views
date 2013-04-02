coffee-views
============

Coffee Views is an extension to [coffee-templates](https://github.com/mikesmullin/coffee-templates) adding template inheritance and an express.js engine.

Installation
------------

`npm i --save coffee-views`

Example
-------

```coffee
# views/layout.coffee

{Base} = require 'coffee-views'

module.exports = class Layout extends Base
  
  # The #render() method is automatically called when rendering the view in express
  render: ->
    doctype 5
    html ->

      head ->
        title @title
        @stylesheets()

      body ->
        h1 @title
        @content()

  stylesheets: ->
  
  content: ->
```

```coffee
# views/myview.coffee

Layout = require './layout'

module.exports = class MyView extends Layout
  content: ->
    div ->
      p 'This is my view'
```

```coffee
View = require './views/myview'
view = new View title: 'My Site'

console.log view.render()
###
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
###
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
  content: ->
    literal super()
    div ->
      p 'This is an extension to "MyView"'

view = new MyExtendedView title: 'My extended view'
console.log view.render()
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

