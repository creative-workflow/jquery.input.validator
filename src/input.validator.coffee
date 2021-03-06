class @InputValidator
  @config =
    options:
      validateOnFocusOut: true
      validateOnKeyUp:    true    # validates only on key up when invalid before
      validateOnClick:    false
      focusOnInvalid:     true
      scrollToOnInvalid:  true
      scrollToOnInvalidOffset: 80
      removeHintOnFocus:  false

    selectors:
      elements: 'input, textarea, select'
      ignore:   ':hidden:not(.force-validate), [readonly]:not(.force-validate)'

    classes:
      invalid: 'invalid error'
      valid:   'valid'
      hint:    'ivalidate-hint' # a hint gets also the valid or invalid class

    messages:
      generic:   'invalid'
      email:     'invalid email'
      tel:       'invalid phone number'
      number:    'invalid number'
      minlength: 'to short'
      maxlength: 'to long'
      min:       'number to low'
      max:       'number to high'
      required:  'required'
      hasClass:  'missing class'
      equal:     'unequal'

    pattern:
      decimal: /^[\d\.]*$/
      number:  /^\d*$/
      tel:     /^[0-9/\-\+\s\(\)]*$/
      # coffeelint: disable
      email: /^\s*([\w!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]+[\w\.!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]*[\w!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]+)@([\w0-9\-\.]{2,63}\.[\w]+)\s*$/
      # coffeelint: enable

    rules:
      number: (validator, $element, value) ->
        return true if $element.attr('type') != 'number' || !(''+value).length
        validator.config.pattern.number.test(validator.strip(value))

      tel: (validator, $element, value) ->
        return true if $element.attr('type') != 'tel' || !(''+value).length
        validator.config.pattern.tel.test(validator.strip(value))

      email: (validator, $element, value) ->
        return true if $element.attr('type') != 'email' || !(''+value).length
        validator.config.pattern.email.test(validator.strip(value))

      pattern: (validator, $element, value) ->
        return true if !$element.attr('pattern') || !(''+value).length
        (''+value).match($element.attr('pattern'))

      hasClass: (validator, $element, value) ->
        return true unless $element.data('rule-has-class')
        $element.hasClass($element.data('rule-has-class'))

      decimal: (validator, $element, value) ->
        return true unless $element.data('rule-decimal') || !(''+value).length
        validator.config.pattern.decimal.test(validator.strip(value))

      required: (validator, $element, value) ->
        return true unless $element.attr('required')
        return false if value == undefined || value == null
        return !!value.length if typeof(value) in ['string', 'array' ]
        !!value

      minlength: (validator, $element, value) ->
        return true unless $element.attr('minlength')
        ('' + value).length >= parseInt($element.attr('minlength'), 10)

      maxlength: (validator, $element, value) ->
        return true unless $element.attr('maxlength')
        ('' + value).length <= parseInt($element.attr('maxlength'), 10)

      min: (validator, $element, value) ->
        return true unless $element.attr('min')
        parseInt(value, 10) >= parseInt($element.attr('min'), 10)

      max: (validator, $element, value) ->
        return true unless $element.attr('max')
        parseInt(value || 0, 10)<= parseInt($element.attr('max'), 10)

      equal: (validator, $element, value, context) ->
        return true unless $element.data('rule-is-equal-to')
        value == $($element.data('rule-is-equal-to'), context).val()


    handler:
      onReset:   null # (validator, $element) ->
      onValid:   null # (validator, $element) ->
      onInvalid: null # (validator, $element, errors) ->

      onGetValidMessage: (validator, $element) ->
        $element.data("msg-valid")

      onGetInvalidMessage: (validator, $element, errors) ->
        error   = errors[0]
        message = $element.data("msg-#{error.rule}")
        message || validator.messageFor(error.rule)

      onBuildHint: (validator, $element, result, message) ->
        classes    = validator.config.classes
        hintClass  = classes.hint
        validClass = if result == true then classes.valid else classes.invalid

        $("<label>", {
          class: hintClass + ' ' + validClass
          for:   $element.attr('id')
        }).html(message)

      onShowHint: (validator, $element, $newHint, $oldHint = null)  ->
        if $newHint && $oldHint && $newHint.text() == $oldHint.text()
          $oldHint.replaceWith($newHint)
          return

        if $newHint
          $newHint.hide().slideUp(1)
          if $element.data('ivalidator-attach-hint-to')
            $($element.data('ivalidator-attach-hint-to')).append($newHint)
          else
            $element.after($newHint)

        unless $oldHint
          $newHint.stop().slideDown(400) if $newHint
          return

        $oldHint.stop().slideUp(400, ->
          $newHint.stop().slideDown(400) if $newHint
          $oldHint.remove()
        )

      onShowHintForTesting: (validator, $element, $newHint, $oldHint = null) ->
        if $newHint
          $element.after($newHint)

        if $oldHint
          $oldHint.remove()

  constructor: (@context, config={}) ->
    @config = @constructor.config
    @init(config, @context)
    @version = '__VERSION__'

  init: (config, context=null) =>
    @config           = jQuery.extend(true, {}, @config, config) if config
    @elementsSelector = @config.selectors.elements
    @ns               = 'ivalidator'
    @prepareElements(context)

  strip: (input) ->
    ret = ''
    x = 0
    while x < input.length
      if input.charCodeAt(x) >= 32 and input.charCodeAt(x) <= 255
        ret += input.charAt(x)
      x++
    ret

  prepareElements: (context=null) =>
    context ?= @context

    $elements = @elementsFor(context)
    if @config.options.validateOnFocusOut
      $elements.off("focusout.#{@ns}")
        .on("focusout.#{@ns}", (e) => @validateOne(e.target))

    if @config.options.removeHintOnFocus
      $elements.off("focus.#{@ns}")
        .on("focus.#{@ns}", (e) => @resetElement(e.target))

    if @config.options.validateOnKeyUp
      $elements.off("keyup.#{@ns}")
        .on("keyup.#{@ns}", (e) =>
          @validateOne(e.target) if $(e.target).data('invalid')
        )

    if @config.options.validateOnClick
      $elements.off("click.#{@ns}")
        .on("click.#{@ns}", (e) => @validateOne(e.target))

  validate: (context = null) =>
    errors = []
    $elements = @elementsFor(context)
    for element in $elements.get()
      result = @validateOne(element, context)
      errors = errors.concat(result) if result != true

    return true unless errors.length

    if @config.options.focusOnInvalid
      $element = $elements.filter( (index, element) =>
        $(element).hasClass(@config.classes.invalid)
      ).first()

      $element.focus()
      if @config.options.scrollToOnInvalid
        offset = @config.options.scrollToOnInvalidOffset
        $('html, body').stop().animate({
          'scrollTop': $element.offset().top - offset
        })

    return errors

  validateOne: (element, context) =>
    context ?= @context
    errors   = []
    $element = $(element)
    if $element.attr('type') in ['checkbox', 'radio']
      name  = $element.attr('name')
      value = $("[name='#{name}']:checked", context).val()
    else
      value    = $element.val()

    for name, rule of @config.rules
      unless rule(@, $element, value, context)
        errors.push {
          element: $element
          rule:    name
          value:   value
        }

    if errors.length == 0
      @onValid($element)
      return true

    @onInvalid($element, errors)
    errors

  reset: (context = null) =>
    for element in @elementsFor(context)
      @resetElement(element)

  resetElement: (element) =>
    $element = $(element)
    @config.handler.onReset?(@, $element)

    $element.removeClass("#{@config.classes.invalid} #{@config.classes.valid}")

    $($element.data('ivalidator-hint')).remove()
    $element.data('ivalidator-hint', null)

  elementsFor: (context = null) =>
    context ?= @context
    return $(context) if @isSingle(context)
    $(@elementsSelector, context)
      .not(@config.selectors.ignore)

  messageFor: (name) =>
    return @config.messages[name] if @config.messages?[name]
    @config.messages.generic

  isSingle: (input) =>
    $(input).is(@elementsSelector)

  shouldBeValidated: (input) =>
    $(input).is(@elementsSelector) && !$(input).is(@ignoreSelector)

  onValid: ($element) =>
    $element.data('invalid', false)
            .data('errors',  null)
            .attr('aria-invalid', 'false')
            .removeClass(@config.classes.invalid)
            .addClass(@config.classes.valid)

    @onProcessHints($element, true)

    @config.handler.onValid?(@, $element)

  onInvalid: ($element, errors) =>
    $element.data('invalid', true)
            .data('errors', errors)
            .attr('aria-invalid', 'true')
            .removeClass(@config.classes.valid)
            .addClass(@config.classes.invalid)

    @onProcessHints($element, errors)

    @config.handler.onInvalid?(@, $element, errors)

  onProcessHints: ($element, result) =>
    $oldHint = $element.data('ivalidator-hint')
    $newHint = null

    if result == true
      message = @config.handler.onGetValidMessage(@, $element)
    else
      message = @config.handler.onGetInvalidMessage(@, $element, result)

    if message
      $newHint = @config.handler.onBuildHint(@, $element, result, message)

    $element.data('ivalidator-hint', $newHint)

    @config.handler.onShowHint(@, $element, $newHint, $oldHint)
