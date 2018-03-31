# jquery.input.validator [![Build Status](https://travis-ci.org/creative-workflow/jquery.input.validator.svg?branch=master)](https://travis-ci.org/creative-workflow/jquery.input.validator) [![Contribute](https://img.shields.io/badge/Contribution-Open-brightgreen.svg)](CONTRIBUTING.md) [![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/badge.svg?style=flat)](https://beerpay.io/creative-workflow/jquery.input.validator)

This [jquery](https://jquery.com) plugin helps to handle **html input validation** by applying rules to elements **based on html attributes**.

It is inspired by [jquery-validation](https://jqueryvalidation.org/) but has **less complexity**, **more comfort** and is easy adjustable for complex setups. Read more in the [Documentation](docs/DOCUMENTATION.md).

It has a high test coverage and is **tested width jquery >1.10, >2 and >3**

## Installation
```bash

bower install jquery.input.validator

# or

npm install jquery.input.validator

```    
## Integration
Insert the following dependencies into your html file:
```html
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="[path_to_your_bower_components]/jquery.input.validator/dist/jquery.input.validator.min.js">
```

## Examples
### Local pattern
```js
$('form').iValidator({
  // custom configuration goes here
});

// validate all inputs in your form
var result = $('form').iValidator().validate();
if( result === true )
  console.log('all inputs valid');

// reset error hints
$('form').iValidator().reset();

// validate element
$('form').iValidator().validateElement(
                                    '<input type="email" value"invalid">'
                                  );
```

### Gobal pattern
```js
var validator = $('body').iValidator({
  // custom configuration goes here
});

// validate all inputs in your form
var result = validator.validate($('form'));
if( result === true )
  console.log('all inputs valid');

// reset the error messages
validator.reset($('form'));
```

### Builtin validators
Validators are triggered from one or more attributes on an input element.
```js

// validators by input type
validator.validateElement('<input type="email"  value"invalid">');
validator.validateElement('<input type="number" value"invalid">');
validator.validateElement('<input type="tel"    value"invalid">');

// validators by html5 attributes
validator.validateElement('<input type="text" required>');
validator.validateElement('<input type="text" minlength="1" maxlength="3">');
validator.validateElement('<input type="text" pattern="^\\d*$">');

// validators by data attributes
validator.validateElement('<input type="text" data-rule-decimal="true">');
validator.validateElement('<input type="text" data-has-class="hello" class="hello">');

// add a custom message for an validator
validator.validateElement('<input type="text" required data-msg-required="required!">');
```

### Dependencies
  * [jquery](https://jquery.com) >=1.10.0 (also tested width >=2, >=3)

### Resources
  * [Documentation](docs/DOCUMENTATION.md)
  * [Changelog](docs/CHANGELOG.md)
  * [Contributing](docs/CONTRIBUTING.md)

### Services
  * [on github.com](https://github.com/creative-workflow/jquery.input.validator)
  * [on bower.io](http://bower.io/search/?q=jquery.input.validator)
  * [on npmjs.org](https://www.npmjs.com/package/jquery.input.validator)
  * [build status](https://travis-ci.org/creative-workflow/jquery.input.validator)

### Authors
  [Tom Hanoldt](https://www.tomhanoldt.info)

## Support on Beerpay
Hey dude! Help me out for a couple of :beers:!

[![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/badge.svg?style=beer)](https://beerpay.io/creative-workflow/jquery.input.validator)  [![Beerpay](https://beerpay.io/creative-workflow/jquery.input.validator/make-wish.svg?style=flat)](https://beerpay.io/creative-workflow/jquery.input.validator?focus=wish)
