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


  it 'should actually work...', ->
    parse = require '@opt/parse'
    parse.use '@opt/nopt'
    parse.use plugin
    result = parse {}, {}, [], 0
    assert.deepEqual result, argv: original:[],cooked:[],remain:[]
