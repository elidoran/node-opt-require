'use strict'

# plugin function for @opt/parse via @use/core
module.exports = (options, opt) ->

  # allow overriding the `require` via options
  theRequire = options?.require ? require

  # we'll use validatePath below, so, grab that
  validatePath = opt.typeDefs.path.validate

  # set our new type into there
  opt.typeDefs.require =

    type: theRequire

    validate: (data, key, value) ->

      # first, it must be a string. (validatePath doesn't quick return for that.)
      unless typeof value is 'string' then return false

      # second, it must be a valid path
      # Note: validatePath will resolve the path, and interpret ~/ home
      # Coverage: ignore if because validatePath always returns true for us
      # because we're testing for a string above, all strings get true.
      ### istanbul ignore if ###
      unless validatePath data, key, value then return false

      # validatePath may have changed value, so, get it from `data` again
      # Note: validatePath will resolve the path, and interpret ~/ home
      try
        data[key] = theRequire data[key]
      catch
        try # one more try with the original value (for module names)
          data[key] = require value
        catch # an error is interpreted as an invalid option
          return false

      # it passed, it's valid.
      return true

  return
