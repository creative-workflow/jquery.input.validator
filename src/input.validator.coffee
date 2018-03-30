class @InputValidator
  @config =
    validateOnFocusOut: true
    validateOnKeyUp: false
    validateOnClick: false

    focusInvalidElement: true
    removeHintOnFocus: false

    selectors:
      elements: 'input, textarea, select'
      ignore: ':hidden'

    classes:
      error: 'error'
      valid: 'valid'
      hint:  'error-hint'

    pattern:
      decimal: /^[\d\.]*$/
      number: /^\d*$/
      tel: /^[0-9/\-\+\s\(\)]*$/
      # coffeelint: disable
      email: /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
      # coffeelint: enable

    rules:
      number: (validator, $element, value) ->
        return true if $element.attr('type') != 'number' || !(''+value).length
        validator.config.pattern.number.test(value)

      tel: (validator, $element, value) ->
        return true if $element.attr('type') != 'tel' || !(''+value).length
        validator.config.pattern.tel.test(value)

      email: (validator, $element, value) ->
        return true if $element.attr('type') != 'email' || !(''+value).length
        validator.config.pattern.email.test(value)

      minlength: (validator, $element, value) ->
        return true unless $element.attr('minlength')
        ('' + value).length >= parseInt($element.attr('minlength'), 10)

      maxlength: (validator, $element, value) ->
        return true unless $element.attr('maxlength')
        ('' + value).length <= parseInt($element.attr('maxlength'), 10)

      required: (validator, $element, value) ->
        return true unless $element.attr('required')
        return false if value == undefined || value == null
        return !!value.length if typeof(value) in ['string', 'array' ]
        !!value

      pattern: (validator, $element, value) ->
        return true if !$element.attr('pattern') || !(''+value).length
        (''+value).match($element.attr('pattern'))

      hasClass: (validator, $element, value) ->
        return true unless $element.data('rule-has-class')
        $element.hasClass($element.data('rule-has-class'))

      decimal: (validator, $element, value) ->
        return true unless $element.data('rule-decimal') || !(''+value).length
        validator.config.pattern.decimal.test(value)

    messages:
      generic:   'invalid'
      email:     'invalid email'
      tel:       'invalid phone number'
      number:    'invalid number'
      minlength: 'to short'
      maxlength: 'to long'
      required:  'required'
      hasClass:  'missing class'

    handler:
      onValid:   null
      onInvalid: null
      onReset:   null
      onBuildErrorElement: (validator, $element, value, errors) ->
        error = errors[0]
        $hint = $element.parent().find(validator.config.classes.hint)

        unless $hint.length
          $hint = $("<label class='#{validator.config.classes.hint}' " +
            "for='#{$element.attr('id')}'>" +
            error.message +
            "</label>")

        $element.data('inputvalidator-hint', $hint)
        $element.after($hint)

      onValidIntern: (validator, $element, value, errors) ->
        classes = validator.config.classes
        validator.config.handler.onResetIntern(validator, $element)
        $element.removeClass(classes.error)
                .addClass(classes.valid)

      onInvalidIntern: (validator, $element, value, errors) ->
        classes = validator.config.classes
        $element.removeClass(classes.valid)
                .addClass(classes.error)

        validator.config.handler.onBuildErrorElement?(
          validator, $element, value, errors)

        validator.config.handler.onInvalid?(validator, $element, value, errors)

      onResetIntern: (validator, $element) ->
        classes = validator.config.classes
        $element.removeClass("#{classes.error} #{classes.valid}")
        $($element.data('inputvalidator-hint')).remove()
        validator.config.handler.onReset?(validator, $element)
        validator.config.handler.onValid?(validator, $element, value, errors)

  constructor: (@context, config={}) ->
    @config = @constructor.config
    @init(config)

  init: (config, context=null) =>
    @config = jQuery.extend(true, {}, @config, config) if config
    @prepareElements(context)
    @config

  prepareElements: (context=null) =>
    context ?= @context

    $elements = @elements(context)
    if @config.validateOnFocusOut
      $elements.focusout (e) =>
        @validateElement(e.target)

    if @config.removeHintOnFocus
      $elements.focus (e) =>
        @resetElement(e.target)

    if @config.validateOnKeyUp
      $elements.keyup (e) =>
        @validateElement(e.target) if $(e.target).data('invalid')

    if @config.validateOnClick
      $elements.click (e) =>
        errors = @validateElement(e.target)


  validate: (context = null) =>
    errors = []
    $elements = @elements(context)
    for element in $elements.get()
      errors = errors.concat(@validateElement(element))

    errors

  validateElement: (element) =>
    $element = $(element)
    value    = $element.val()
    errors   = []

    for name, rule of @config.rules
      unless rule(@, $element, value)
        errors.push {
          message: $element.data("msg-#{name}") || @getMessage(name)
          element: $element
          rule: name
          value:   value
        }

    if errors.length > 0
      $element.data('invalid', true)
      @config.handler.onInvalidIntern(@, $element, value, errors)
      $element.first().focus() if @config.focusInvalidElement

    else
      $element.data('invalid', false)
      @config.handler.onValidIntern(@, $element, value, errors)

    errors

  reset: (context = null) =>
    @resetElement(@elements(context))

  resetElement: ($element) =>
    @config.handler.onResetIntern(@, $element)

  elements: (context = null) =>
    context ?= @context
    $(@config.selectors.elements, context)
      .not(@config.selectors.ignore)

  getMessage: (name) =>
    return @config.messages.generic unless @config.messages?[name]
    @config.messages[name]
