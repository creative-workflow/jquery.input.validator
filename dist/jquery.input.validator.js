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
        onBuildErrorHint: function(validator, $element, value, errors) {
          return $(("<label class='" + validator.config.classes.hint + "' ") + ("for='" + ($element.attr('id')) + "'></label>"));
        },
        onBuildErrorHintIntern: function(validator, $element, value, errors) {
          var $hint, error;
          error = errors[0];
          $hint = $element.data('inputvalidator-hint');
          if (!$hint) {
            $hint = validator.config.handler.onBuildErrorHint(validator, $element, value, errors);
            $element.data('inputvalidator-hint', $hint).after($hint);
          }
          return $hint.html(error.message);
        },
        onValidIntern: function(validator, $element, value, errors) {
          var classes;
          classes = validator.config.classes;
          validator.config.handler.onResetIntern(validator, $element);
          return $element.removeClass(classes.error).addClass(classes.valid);
        },
        onInvalidIntern: function(validator, $element, value, errors) {
          var base, classes;
          classes = validator.config.classes;
          $element.removeClass(classes.valid).addClass(classes.error);
          validator.config.handler.onBuildErrorHintIntern(validator, $element, value, errors);
          return typeof (base = validator.config.handler).onInvalid === "function" ? base.onInvalid(validator, $element, value, errors) : void 0;
        },
        onResetIntern: function(validator, $element) {
          var base, base1, classes;
          classes = validator.config.classes;
          $element.removeClass(classes.error + " " + classes.valid);
          $($element.data('inputvalidator-hint')).remove();
          $element.data('inputvalidator-hint', null);
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
      this.messageFor = bind(this.messageFor, this);
      this.elementsFor = bind(this.elementsFor, this);
      this.resetElement = bind(this.resetElement, this);
      this.reset = bind(this.reset, this);
      this.validateOne = bind(this.validateOne, this);
      this.validate = bind(this.validate, this);
      this.prepareElements = bind(this.prepareElements, this);
      this.init = bind(this.init, this);
      this.config = this.constructor.config;
      this.ns = 'inputvalidator';
      this.version = '1.0.7';
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
      $elements = this.elementsFor(context);
      if (this.config.validateOnFocusOut) {
        $elements.off("focusout." + this.ns).on("focusout." + this.ns, (function(_this) {
          return function(e) {
            return _this.validateOne(e.target);
          };
        })(this));
      }
      if (this.config.removeHintOnFocus) {
        $elements.off("focus." + this.ns).on("focus." + this.ns, (function(_this) {
          return function(e) {
            return _this.resetElement(e.target);
          };
        })(this));
      }
      if (this.config.validateOnKeyUp) {
        $elements.off("keyup." + this.ns).on("keyup." + this.ns, (function(_this) {
          return function(e) {
            if ($(e.target).data('invalid')) {
              return _this.validateOne(e.target);
            }
          };
        })(this));
      }
      if (this.config.validateOnClick) {
        return $elements.off("click." + this.ns).on("click." + this.ns, (function(_this) {
          return function(e) {
            return _this.validateOne(e.target);
          };
        })(this));
      }
    };

    InputValidator.prototype.validate = function(context) {
      var $elements, element, errors, i, len, ref, result;
      if (context == null) {
        context = null;
      }
      errors = [];
      $elements = this.elementsFor(context);
      ref = $elements.get();
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        result = this.validateOne(element);
        if (result !== true) {
          errors = errors.concat(result);
        }
      }
      if (errors.length) {
        return errors;
      } else {
        return true;
      }
    };

    InputValidator.prototype.validateOne = function(element) {
      var $element, errors, name, ref, rule, value;
      $element = $(element);
      value = $element.val();
      errors = [];
      ref = this.config.rules;
      for (name in ref) {
        rule = ref[name];
        if (!rule(this, $element, value)) {
          errors.push({
            message: $element.data("msg-" + name) || this.messageFor(name),
            element: $element,
            rule: name,
            value: value
          });
        }
      }
      if (errors.length === 0) {
        $element.data('invalid', false);
        this.config.handler.onValidIntern(this, $element, value, errors);
        return true;
      }
      $element.data('invalid', true);
      this.config.handler.onInvalidIntern(this, $element, value, errors);
      if (this.config.focusInvalidElement) {
        $element.first().focus();
      }
      return errors;
    };

    InputValidator.prototype.reset = function(context) {
      var element, i, len, ref, results;
      if (context == null) {
        context = null;
      }
      ref = this.elementsFor(context);
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        results.push(this.resetElement(element));
      }
      return results;
    };

    InputValidator.prototype.resetElement = function(element) {
      return this.config.handler.onResetIntern(this, $(element));
    };

    InputValidator.prototype.elementsFor = function(context) {
      if (context == null) {
        context = null;
      }
      if (context == null) {
        context = this.context;
      }
      return $(this.config.selectors.elements, context).not(this.config.selectors.ignore);
    };

    InputValidator.prototype.messageFor = function(name) {
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
    jQuery.fn.iValidator = function(config) {
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

//# sourceMappingURL=jquery.input.validator.js.map
