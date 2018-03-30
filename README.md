# jquery.input.validator [![Build Status](https://travis-ci.org/creative-workflow/jquery.input.validator.svg?branch=master)](https://travis-ci.org/creative-workflow/jquery.input.validator) [![Contribute](https://img.shields.io/badge/Contribution-Open-brightgreen.svg)](CONTRIBUTING.md) [![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/badge.svg?style=flat)](https://beerpay.io/creative-workflow/jquery.input.validator)

[![NPM](https://nodei.co/npm/jquery.input.validator.png)](https://nodei.co/npm/jquery.input.validator/)

This module helps to handle input validation based on standard html attributes.

It is inspired by [jquery-validation](https://jqueryvalidation.org/) but has much less complexity, more comfort and is easy adjustable for complex setups.

_Note: early stage_

## Installation
```bash

bower install jquery.input.validator

# or

npm install jquery.input.validator

```    

## Usage
### javascript
```js
validator = $('body').inputValidator({
  ...
});

$('form').inputValidator().validate()
$('form').inputValidator().reset()

errors = validator.validateElement('<input type="email" value"invalid">')
errors = validator.validateElement('<input type="number" value"invalid">')
errors = validator.validateElement('<input type="tel" value"invalid">')
errors = validator.validateElement('<input type="text" required>')
errors = validator.validateElement('<input type="text" minlength="1" maxlength="3">')

errors = validator.validateElement('<input type="text" data-rule-decimal="true">')
errors = validator.validateElement('<input type="text" data-rule-pattern="true" pattern="blub[\\d*]" value="blub23" >')
errors = validator.validateElement('<input type="text" data-has-class="hello" class="hello">')

errors = validator.validateElement('<input type="text" required data-msg-required="required">')

// TODO: write docs
```
It also exposes the class `InputValidator` for manual instantiating.

### Configuration
####
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
    email: /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

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

```


### Dependencies
  * [jquery](https://jquery.com)

### Resources
  * https://github.com/creative-workflow/jquery.input.validator
  * https://travis-ci.org/creative-workflow/jquery.input.validator
  * https://codeclimate.com/github/creative-workflow/jquery.input.validator
  * http://bower.io/search/?q=jquery.input.validator

### Development
#### Setup
  * `npm install`
  * `bower install`
  * `npm run test`

#### Run tests and linter
  * `npm run test`

#### Generate build
  * `npm run build`

### Authors

  [Tom Hanoldt](https://www.tomhanoldt.info)

## Changelog
### 1.0.1
  * readme
  
### 1.0.0
  * initial

# Contributing

Check out the [Contributing Guidelines](CONTRIBUTING.md)


## Support on Beerpay
Hey dude! Help me out for a couple of :beers:!

[![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/badge.svg?style=beer)](https://beerpay.io/creative-workflow/jquery.input.validator)  [![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/make-wish.svg?style=flat)](https://beerpay.io/creative-workflow/jquery.input.validator?focus=wish)
