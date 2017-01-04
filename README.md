# @opt/require
[![Build Status](https://travis-ci.org/elidoran/node-opt-require.svg?branch=master)](https://travis-ci.org/elidoran/node-opt-require)
[![Dependency Status](https://gemnasium.com/elidoran/node-opt-require.png)](https://gemnasium.com/elidoran/node-opt-require)
[![npm version](https://badge.fury.io/js/%40opt%2Frequire.svg)](http://badge.fury.io/js/%40opt%2Frequire)
[![Coverage Status](https://coveralls.io/repos/github/elidoran/node-opt-require/badge.svg?branch=master)](https://coveralls.io/github/elidoran/node-opt-require?branch=master)

Plugin for @opt/parse adding type def which calls require() on the value.

It adds to nopt's `typeDef` a new type marked by the string `require`. When an option has that type it is tested as a path first, then, `require()` is called on it to get the result, which is placed into the parsed options.

Basically, you can do an option like: `name: require` and `name: [require, Array]` and you'll get back the result of the require operation in the `name` property.

See [@opt/parse](https://www.npmjs.com/package/@opt/parse)

See [@opt/nopt](https://www.npmjs.com/package/nopt)

See [@use/core](https://www.npmjs.com/package/@use/core)


## Install

```sh
npm install @opt/require --save
```


## Usage

```javascript
var parse = require('@opt/parse')

// make nopt the parser and apply our require plugin
parse.use('@opt/nopt', '@opt/require')

var options = {
  // the type def is marked with string 'require()'
  // this allows multiple of them, set into an array.
  plugin: [require, Array]
}

// an example args array with a plugin option to require()
// the module path must be absolute, or relative to CWD. or use ~/
var argv = [ 'node', 'some.js', '--plugin', 'some/module' ]

// then use parse as you would use `nopt`,
// plus any changes made possible by the plugins added
options = parse(options, {}, argv, 2)

// the above would produce:
options = {
  // can't write a function... so, 'theModuleFunction' means a real function
  // returned by require('some/module')
  plugin: [ theModuleFunction ]
  argv: {
    original: [ 'node', 'some.js', '--plugin', 'some/module' ]
    original: [ 'node', 'some.js', '--plugin', 'some/module' ]
    remain  : []
  }
}
```


## MIT License
