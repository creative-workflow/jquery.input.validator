
#= include input.validator.coffee

if typeof jQuery != 'undefined'
  $ = jQuery
  jQuery.fn.iValidator = (config = null) ->
    $this = $(this)

    instance = $this.data('inputvalidator')

    if !instance || config != null
      $this.data('inputvalidator', new InputValidator($this, config || {}))

      instance = $this.data('inputvalidator')

    return instance
