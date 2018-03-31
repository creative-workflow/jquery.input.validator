# Documentation

### Validators
```js

// validators by input type
validator.validateElement('<input type="email"  value"invalid">');
validator.validateElement('<input type="number" value"invalid">');
validator.validateElement('<input type="tel"    value"invalid">');

// validators by html5 attributes
validator.validateElement('<input type="text" required>')
validator.validateElement('<input type="text" minlength="1" maxlength="3">')
validator.validateElement('<input type="text" pattern="^\\d*$">')

// validators by data attributes
validator.validateElement('<input type="text" data-rule-decimal="true">')
validator.validateElement('<input type="text" data-has-class="hello" class="hello">')

// add a custom message for an validator
validator.validateElement('<input type="text" required data-msg-required="required!">')
```

##### Custom valiators
```js
var validator = $('body').iValidator({
  rules:{
    helloWorld: function(validator, $element, value){
      if(!$element.data('rule-hello-world'))
        return true;

      return value == $element.data('rule-hello-world');
    }      
  },
  messages:{
    helloWorld: 'this is not "hello world"'    
  }
});

var invalidHelloWorld = '<input type="text" "data-rule-hello-world"="hello world" value="not hello world">';

errors = validator.validateElement(invalidHelloWorld);

if(errors !== false)
  console.log('hello world from custom validator =)');

```

### Methods
##### validate(context = null)
  * calls `validateElement` for every element in `context`
  * `returns` array of erros or `true`
  * `context` can be a html string or jquery object
  * default `context` is the element you attached the `iValidator` to

##### validateElement(element)
  * `element` can be string or jquery object
  * `returns` array of erros or `true`
  * applies the `rules` on the element, this means:
    * adds handler for `keyup` and `focusout` etc. (detaches the old one)
    * adds class `valid` or `invalid` to element
    * if `invalid` it adds the error label to the parent element
    * if `valid` id removes the error label
    * sets a data attribute `data-invalid` after validation

##### reset(context = null) =>
  * calls `resetElement` for every element in `context`
  * `context` can be a html string or jquery object
  * default `context` is the element you attached the `iValidator` to

##### resetElement(element)
  * `element` can be string or jquery object
  * removes handler for `keyup` and `focusout`
  * removes `error`/`valid` class from element

##### elementsFor(context = null)
  * `returns` the elements that should be validated in `context`
  * uses `@config.selectors.elements`
  * ignores `@config.selectors.ignore`
  * `context` can be a html string or jquery object
  * default `context` is the element you attached the `iValidator` to

##### messageFor(name)
  * looks in `@config.messages` for a message for `name`
  * returns `@config.messages.generic` when no message found

### Configuration
```coffee
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
```


### Override internal behaviour
It is very easy to override the internal behaviour as all specific logic is also implemented via `@config.handler`.

Have a look at the current implementation:
```coffee
@config.handler =
  onValid:   null
  onInvalid: null
  onReset:   null
  onBuildErrorHint: (validator, $element, value, errors) ->
    $("<label class='#{validator.config.classes.hint}' " +
      "for='#{$element.attr('id')}'></label>")

  onBuildErrorHintIntern: (validator, $element, value, errors) ->
    error = errors[0]
    $hint = $element.data('inputvalidator-hint')

    unless $hint
      $hint = validator.config.handler.onBuildErrorHint(validator,
        $element, value, errors)

      $element.data('inputvalidator-hint', $hint)
              .after($hint)

    $hint.html(error.message)

  onValidIntern: (validator, $element, value, errors) ->
    classes = validator.config.classes
    validator.config.handler.onResetIntern(validator, $element)
    $element.removeClass(classes.error)
            .addClass(classes.valid)

  onInvalidIntern: (validator, $element, value, errors) ->
    classes = validator.config.classes
    $element.removeClass(classes.valid)
            .addClass(classes.error)

    validator.config.handler.onBuildErrorHintIntern(
      validator, $element, value, errors)

    validator.config.handler.onInvalid?(validator, $element, value, errors)

  onResetIntern: (validator, $element) ->
    classes = validator.config.classes
    $element.removeClass("#{classes.error} #{classes.valid}")
    $($element.data('inputvalidator-hint')).remove()
    $element.data('inputvalidator-hint', null)
    validator.config.handler.onReset?(validator, $element)
    validator.config.handler.onValid?(validator, $element, value, errors)

```

I think there is potential to implement this more elegant: [Contributing](CONTRIBUTING.md) =)

### Resources
  * [Readme](../README.md)
  * [Documentation](DOCUMENTATION.md)
  * [Changelog](CHANGELOG.md)
  * [Contributing](CONTRIBUTING.md)