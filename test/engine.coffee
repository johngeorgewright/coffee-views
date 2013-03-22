CoffeeTemplate = require 'coffee-templates'
engine         = require '../lib/engine'
express        = require 'express'
path           = require 'path'
sinon          = require 'sinon'

exports['#engine()'] =

  setUp: (done)->
    @app = express()
    @app.engine 'coffee', engine
    @app.set 'view engine', 'coffee'
    @app.set 'views', path.join __dirname, 'views'
    done()

  'it can render a basic template with out any options': (test)->
    @app.render 'basic',
      _locals: {}
    , (err, html)->
      test.ifError err
      test.equal html, '<!doctype html><html><head></head><body></body></html>'
      test.done()

  'it can render a template with parameters': (test)->
    @app.render 'with-parameters',
      title: 'Title',
      _locals: {}
    , (err, html)->
      test.ifError err
      test.equal html, '<!doctype html><html><head><title>Title</title></head><body><h1>Title</h1></body></html>'
      test.done()

  'it is extensible': (test)->
    @app.render 'extensible',
      title: 'Title'
      _locals: {}
    , (err, html)->
      test.ifError err
      test.equal html, '<!doctype html><html><head><title>Title</title><meta encoding="utf8"/></head><body><h1>Title</h1></body></html>'
      test.done()

  'it is highly extensible': (test)->
    @app.render 'highly-extensible',
      title: 'Title'
      _locals: {}
    , (err, html)->
      test.ifError err
      test.equal html, '<!doctype html><html><head><title>Title</title><meta encoding="utf8"/><meta name="description" content="A description"/></head><body><h1>Title</h1></body></html>'
      test.done()

