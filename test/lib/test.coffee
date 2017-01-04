assert = require 'assert'
plugin = require '../../lib'

describe 'test plugin', ->

  it 'should add to typeDefs', ->
    opt = parse: typeDefs: path: validate: ->
    plugin {require:require}, opt
    assert opt.parse.typeDefs.require, 'it should be in typeDefs now'
    assert.equal typeof(opt.parse.typeDefs.require.validate), 'function', 'there should be a validate function'

  it 'should not validate a non-string', ->
    opt = parse: typeDefs: path: validate: ->
    plugin {require:require}, opt
    data = key:123
    result = opt.parse.typeDefs.require.validate data, 'key', 123
    assert.equal result, false

  it 'should not validate when validatePath returns false', ->
    opt = parse: typeDefs: path: validate: -> false
    plugin {require:require}, opt
    data = key:123
    result = opt.parse.typeDefs.require.validate data, 'key', 123
    assert.equal result, false

  it 'should not validate a string for an invalid path/module', ->
    opt = parse: typeDefs: path: validate: -> true
    plugin {require:require}, opt
    data = key:'badname'
    result = opt.parse.typeDefs.require.validate data, 'key', 'badname'
    assert.equal result, false

  it 'should validate a string for a valid path/module', ->
    opt = parse: typeDefs: path: validate: -> true
    plugin {require:require}, opt
    data = key:'coffee-script'
    result = opt.parse.typeDefs.require.validate data, 'key', 'coffee-script'
    assert.equal result, true


  it 'should actually run', ->
    parse = require '@opt/parse'
    parse.use '@opt/nopt'
    parse.use plugin
    result = parse {}, {}, [], 0
    assert.deepEqual result, argv: original:[],cooked:[],remain:[]

  it 'should actually work', ->
    parse = require '@opt/parse'
    parse.use '@opt/nopt'
    parse.use plugin
    result = parse {plugin: require}, {}, ['--plugin', 'test/some-module'], 0
    assert.deepEqual result,
      plugin: require('../some-module')
      argv:
        original:['--plugin', 'test/some-module']
        cooked:['--plugin', 'test/some-module']
        remain:[]

  it 'should actually work with many', ->

    # get the main part
    parse = require '@opt/parse'
    # add the plugin we need
    parse.use '@opt/nopt'
    # add our plugin
    parse.use plugin

    # input for this operation
    input = [
      { plugin: [require, Array] }
      {}
      ['--plugin', 'test/some-module', '--plugin', 'test/another-module']
      0
    ]

    # the result of parsing the above input
    answer =
      plugin: [require('../some-module'), require('../another-module')]
      argv:
        original:['--plugin', 'test/some-module', '--plugin', 'test/another-module']
        cooked  :['--plugin', 'test/some-module', '--plugin', 'test/another-module']
        remain  :[]

    result = parse.apply parse, input
    assert.deepEqual result, answer
