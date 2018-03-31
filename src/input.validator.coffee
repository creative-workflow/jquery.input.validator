class @InputValidator
  @config =
    options:
      validateOnFocusOut: true
      validateOnKeyUp:    true    # validates only on key up when invalid before
      validateOnClick:    false
      focusOnInvalid:     true
      removeHintOnFocus:  false

    selectors:
      elements: 'input, textarea, select'
      ignore:   ':hidden'

    classes:
      invalid: 'invalid'
      valid:   'valid'
      hint:    'error-hint'

    pattern:
      decimal: /^[\d\.]*$/
      number:  /^\d*$/
      tel:     /^[0-9/\-\+\s\(\)]*$/
      # coffeelint: disable
      email:   /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
      # coffeelint: enable

    rules:
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

      number: (validator, $element, value) ->
        return true if $element.attr('type') != 'number' || !(''+value).length
        validator.config.pattern.number.test(value)

      tel: (validator, $element, value) ->
        return true if $element.attr('type') != 'tel' || !(''+value).length
        validator.config.pattern.tel.test(value)

      email: (validator, $element, value) ->
        return true if $element.attr('type') != 'email' || !(''+value).length
        validator.config.pattern.email.test(value)

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
      onBuildErrorHint: (validator, $element, value, errors) ->
        $("<label class='#{validator.config.classes.hint}' " +
          "for='#{$element.attr('id')}'></label>")

      onBuildErrorHintIntern: (validator, $element, value, errors) ->
        error = errors[0]
        $hint = $element.data('ivalidator-hint')

        unless $hint
          $hint = validator.config.handler.onBuildErrorHint(validator,
            $element, value, errors)

          $element.data('ivalidator-hint', $hint)
                  .after($hint)

        $hint.html(error.message)

      onValidIntern: (validator, $element, value, errors) ->
        classes = validator.config.classes
        validator.config.handler.onResetIntern(validator, $element)
        $element.removeClass(classes.invalid)
                .addClass(classes.valid)

      onInvalidIntern: (validator, $element, value, errors) ->
        classes = validator.config.classes
        $element.removeClass(classes.valid)
                .addClass(classes.invalid)

        validator.config.handler.onBuildErrorHintIntern(
          validator, $element, value, errors)

        validator.config.handler.onInvalid?(validator, $element, value, errors)

      onResetIntern: (validator, $element) ->
        classes = validator.config.classes
        $element.removeClass("#{classes.invalid} #{classes.valid}")
        $($element.data('ivalidator-hint')).remove()
        $element.data('ivalidator-hint', null)
        validator.config.handler.onReset?(validator, $element)
        validator.config.handler.onValid?(validator, $element, value, errors)

  constructor: (@context, config={}) ->
    @config  = @constructor.config
    @ns      = 'ivalidator'
    @version = '__VERSION__'
    @init(config)

  init: (config, context=null) =>
    @config = jQuery.extend(true, {}, @config, config) if config
    @prepareElements(context)
    @config

  prepareElements: (context=null) =>
    context ?= @context

    $elements = @elementsFor(context)
    if @config.options.validateOnFocusOut
      $elements
        .off("focusout.#{@ns}")
        .on("focusout.#{@ns}", (e) => @validateOne(e.target))

    if @config.options.removeHintOnFocus
      $elements
        .off("focus.#{@ns}")
        .on("focus.#{@ns}", (e) => @resetElement(e.target))

    if @config.options.validateOnKeyUp
      $elements
        .off("keyup.#{@ns}")
        .on("keyup.#{@ns}", (e) =>
          @validateOne(e.target) if $(e.target).data('invalid')
        )

    if @config.options.validateOnClick
      $elements
        .off("click.#{@ns}")
        .on("click.#{@ns}", (e) => @validateOne(e.target))

  validate: (context = null) =>
    errors = []
    $elements = @elementsFor(context)
    for element in $elements.get()
      result = @validateOne(element)
      errors = errors.concat(result) if result != true

    return if errors.length then errors else true

  validateOne: (element) =>
    $element = $(element)
    value    = $element.val()
    errors   = []

    for name, rule of @config.rules
      unless rule(@, $element, value)
        errors.push {
          message: $element.data("msg-#{name}") || @messageFor(name)
          element: $element
          rule: name
          value:   value
        }

    if errors.length == 0
      $element.data('invalid', false)
      @config.handler.onValidIntern(@, $element, value, errors)
      return true

    $element.data('invalid', true)
    @config.handler.onInvalidIntern(@, $element, value, errors)
    $element.first().focus() if @config.options.focusOnInvalid
    errors

  reset: (context = null) =>
    for element in @elementsFor(context)
      @resetElement(element)

  resetElement: (element) =>
    @config.handler.onResetIntern(@, $(element))

  elementsFor: (context = null) =>
    context ?= @context
    $(@config.selectors.elements, context)
      .not(@config.selectors.ignore)

  messageFor: (name) =>
    return @config.messages.generic unless @config.messages?[name]
    @config.messages[name]
