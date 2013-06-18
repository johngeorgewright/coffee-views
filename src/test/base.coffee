path = require 'path'
Base = require '../lib/base'

module.exports =

  setUp: (done) ->
    @base = new Base()
    done()

  '#compile()':

    'will render some functions as tags': (test)->
      result = 'I love dogs'
      html = @base.compile ->
        @lit 'I love '
        @lit 'dogs'
      test.equal @base._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

    'will use a method from it\'s own instance when a string is passed as the first argument': (test)->
      result = 'I love cookies'
      class Template extends Base
        render: ->
          @lit 'I love'
          @lit ' cookies'
      template = new Template()
      html = template.compile 'render'
      test.equal template._content, result, 'it did not add the content to the #_content property'
      test.equal html, result, 'it did not return the #_content property'
      test.done()

  '#partial()':

    'it will compile a view referenced by a path': (test) ->
      html = @base.compile ->
        @lit 'mungface '
        @partial path.join __dirname, 'views', 'basic'
      test.equal html, 'mungface <!doctype html><html><head></head><body></body></html>'
      test.done()

    'it will compile another class': (test) ->
      view = @base.compile ->
        @partial require './views/basic'
        @lit ' nasty'
      test.equal view, '<!doctype html><html><head></head><body></body></html> nasty'
      test.done()

