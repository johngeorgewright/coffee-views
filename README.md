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
  
  # The #render() method is automatically called when rendering the view
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

Due to the nature of coffee-templates, CoffeeScript's native `super()` method cannot be used. Instead, you can use a `parent([methodName])` function:

```coffee
class MyExtendedView extends MyView
  content: ->
    literal parent 'content'
    div ->
      p 'This is an extension to "MyView"'
```

