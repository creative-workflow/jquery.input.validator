(function() {
  var $,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.InputValidator = (function() {
    InputValidator.config = {
      validateOnFocusOut: true,
      validateOnKeyUp: false,
      validateOnClick: false,
      focusInvalidElement: true,
      removeHintOnFocus: false,
      selectors: {
        elements: 'input, textarea, select',
        ignore: ':hidden'
      },
      classes: {
        error: 'error',
        valid: 'valid',
        hint: 'error-hint'
      },
      pattern: {
        decimal: /^[\d\.]*$/,
        number: /^\d*$/,
        tel: /^[0-9\/\-\+\s\(\)]*$/,
        email: /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
      },
      rules: {
        minlength: function(validator, $element, value) {
          if (!$element.attr('minlength')) {
            return true;
          }
          return ('' + value).length >= parseInt($element.attr('minlength'), 10);
        },
        maxlength: function(validator, $element, value) {
          if (!$element.attr('maxlength')) {
            return true;
          }
          return ('' + value).length <= parseInt($element.attr('maxlength'), 10);
        },
        required: function(validator, $element, value) {
          var ref;
          if (!$element.attr('required')) {
            return true;
          }
          if (value === void 0 || value === null) {
            return false;
          }
          if ((ref = typeof value) === 'string' || ref === 'array') {
            return !!value.length;
          }
          return !!value;
        },
        number: function(validator, $element, value) {
          if ($element.attr('type') !== 'number' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.number.test(value);
        },
        tel: function(validator, $element, value) {
          if ($element.attr('type') !== 'tel' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.tel.test(value);
        },
        email: function(validator, $element, value) {
          if ($element.attr('type') !== 'email' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.email.test(value);
        },
        pattern: function(validator, $element, value) {
          if (!$element.attr('pattern') || !('' + value).length) {
            return true;
          }
          return ('' + value).match($element.attr('pattern'));
        },
        hasClass: function(validator, $element, value) {
          if (!$element.data('rule-has-class')) {
            return true;
          }
          return $element.hasClass($element.data('rule-has-class'));
        },
        decimal: function(validator, $element, value) {
          if (!($element.data('rule-decimal') || !('' + value).length)) {
            return true;
          }
          return validator.config.pattern.decimal.test(value);
        }
      },
      messages: {
        generic: 'invalid',
        email: 'invalid email',
        tel: 'invalid phone number',
        number: 'invalid number',
        minlength: 'to short',
        maxlength: 'to long',
        required: 'required',
        hasClass: 'missing class'
      },
      handler: {
        onValid: null,
        onInvalid: null,
        onReset: null,
        onBuildErrorElement: function(validator, $element, value, errors) {
          var $hint, error;
          error = errors[0];
          $hint = $element.data('inputvalidator-hint');
          if ($hint) {
            $hint.html(error.message);
            return;
          }
          $hint = $(("<label class='" + validator.config.classes.hint + "' ") + ("for='" + ($element.attr('id')) + "'>") + error.message + "</label>");
          return $element.data('inputvalidator-hint', $hint).after($hint);
        },
        onValidIntern: function(validator, $element, value, errors) {
          var classes;
          classes = validator.config.classes;
          validator.config.handler.onResetIntern(validator, $element);
          return $element.removeClass(classes.error).addClass(classes.valid);
        },
        onInvalidIntern: function(validator, $element, value, errors) {
          var base, base1, classes;
          classes = validator.config.classes;
          $element.removeClass(classes.valid).addClass(classes.error);
          if (typeof (base = validator.config.handler).onBuildErrorElement === "function") {
            base.onBuildErrorElement(validator, $element, value, errors);
          }
          return typeof (base1 = validator.config.handler).onInvalid === "function" ? base1.onInvalid(validator, $element, value, errors) : void 0;
        },
        onResetIntern: function(validator, $element) {
          var base, base1, classes;
          classes = validator.config.classes;
          $element.removeClass(classes.error + " " + classes.valid);
          $($element.data('inputvalidator-hint')).remove();
          $element.data('inputvalidator-hint', void 0);
          if (typeof (base = validator.config.handler).onReset === "function") {
            base.onReset(validator, $element);
          }
          return typeof (base1 = validator.config.handler).onValid === "function" ? base1.onValid(validator, $element, value, errors) : void 0;
        }
      }
    };

    function InputValidator(context1, config) {
      this.context = context1;
      if (config == null) {
        config = {};
      }
      this.getMessage = bind(this.getMessage, this);
      this.elements = bind(this.elements, this);
      this.resetElement = bind(this.resetElement, this);
      this.reset = bind(this.reset, this);
      this.validateElement = bind(this.validateElement, this);
      this.validate = bind(this.validate, this);
      this.prepareElements = bind(this.prepareElements, this);
      this.init = bind(this.init, this);
      this.config = this.constructor.config;
      this.init(config);
    }

    InputValidator.prototype.init = function(config, context) {
      if (context == null) {
        context = null;
      }
      if (config) {
        this.config = jQuery.extend(true, {}, this.config, config);
      }
      this.prepareElements(context);
      return this.config;
    };

    InputValidator.prototype.prepareElements = function(context) {
      var $elements;
      if (context == null) {
        context = null;
      }
      if (context == null) {
        context = this.context;
      }
      $elements = this.elements(context);
      if (this.config.validateOnFocusOut) {
        $elements.focusout((function(_this) {
          return function(e) {
            return _this.validateElement(e.target);
          };
        })(this));
      }
      if (this.config.removeHintOnFocus) {
        $elements.focus((function(_this) {
          return function(e) {
            return _this.resetElement(e.target);
          };
        })(this));
      }
      if (this.config.validateOnKeyUp) {
        $elements.keyup((function(_this) {
          return function(e) {
            if ($(e.target).data('invalid')) {
              return _this.validateElement(e.target);
            }
          };
        })(this));
      }
      if (this.config.validateOnClick) {
        return $elements.click((function(_this) {
          return function(e) {
            var errors;
            return errors = _this.validateElement(e.target);
          };
        })(this));
      }
    };

    InputValidator.prototype.validate = function(context) {
      var $elements, element, errors, i, len, ref;
      if (context == null) {
        context = null;
      }
      errors = [];
      $elements = this.elements(context);
      ref = $elements.get();
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        errors = errors.concat(this.validateElement(element));
      }
      return errors;
    };

    InputValidator.prototype.validateElement = function(element) {
      var $element, errors, name, ref, rule, value;
      $element = $(element);
      value = $element.val();
      errors = [];
      ref = this.config.rules;
      for (name in ref) {
        rule = ref[name];
        if (!rule(this, $element, value)) {
          errors.push({
            message: $element.data("msg-" + name) || this.getMessage(name),
            element: $element,
            rule: name,
            value: value
          });
        }
      }
      if (errors.length > 0) {
        $element.data('invalid', true);
        this.config.handler.onInvalidIntern(this, $element, value, errors);
        if (this.config.focusInvalidElement) {
          $element.first().focus();
        }
      } else {
        $element.data('invalid', false);
        this.config.handler.onValidIntern(this, $element, value, errors);
      }
      return errors;
    };

    InputValidator.prototype.reset = function(context) {
      if (context == null) {
        context = null;
      }
      return this.resetElement(this.elements(context));
    };

    InputValidator.prototype.resetElement = function($element) {
      return this.config.handler.onResetIntern(this, $element);
    };

    InputValidator.prototype.elements = function(context) {
      if (context == null) {
        context = null;
      }
      if (context == null) {
        context = this.context;
      }
      return $(this.config.selectors.elements, context).not(this.config.selectors.ignore);
    };

    InputValidator.prototype.getMessage = function(name) {
      var ref;
      if (!((ref = this.config.messages) != null ? ref[name] : void 0)) {
        return this.config.messages.generic;
      }
      return this.config.messages[name];
    };

    return InputValidator;

  })();

  if (typeof jQuery !== 'undefined') {
    $ = jQuery;
    jQuery.fn.inputValidator = function(config) {
      var $this, instance;
      if (config == null) {
        config = null;
      }
      $this = $(this);
      instance = $this.data('inputvalidator');
      if (!instance || config !== null) {
        $this.data('inputvalidator', new InputValidator($this, config || {}));
        instance = $this.data('inputvalidator');
      }
      return instance;
    };
  }

}).call(this);
