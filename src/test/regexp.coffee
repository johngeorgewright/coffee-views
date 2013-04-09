regExpHelper = require '../lib/regexp'

module.exports =

  '#escape()':

    'it should escape all know characters used in a regular expression': (test)->
      result = regExpHelper.escape '[]^$()'
      test.equal result, '\\[\\]\\^\\$\\(\\)'
      test.done()

