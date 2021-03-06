(function() {
  var $,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.InputValidator = (function() {
    InputValidator.config = {
      options: {
        validateOnFocusOut: true,
        validateOnKeyUp: true,
        validateOnClick: false,
        focusOnInvalid: true,
        scrollToOnInvalid: true,
        scrollToOnInvalidOffset: 80,
        removeHintOnFocus: false
      },
      selectors: {
        elements: 'input, textarea, select',
        ignore: ':hidden:not(.force-validate), [readonly]:not(.force-validate)'
      },
      classes: {
        invalid: 'invalid error',
        valid: 'valid',
        hint: 'ivalidate-hint'
      },
      messages: {
        generic: 'invalid',
        email: 'invalid email',
        tel: 'invalid phone number',
        number: 'invalid number',
        minlength: 'to short',
        maxlength: 'to long',
        min: 'number to low',
        max: 'number to high',
        required: 'required',
        hasClass: 'missing class',
        equal: 'unequal'
      },
      pattern: {
        decimal: /^[\d\.]*$/,
        number: /^\d*$/,
        tel: /^[0-9\/\-\+\s\(\)]*$/,
        email: /^\s*([\w!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]+[\w\.!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]*[\w!#\$%&\'\*\+\-\/=\?\^`\{\|\}_~]+)@([\w0-9\-\.]{2,63}\.[\w]+)\s*$/
      },
      rules: {
        number: function(validator, $element, value) {
          if ($element.attr('type') !== 'number' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.number.test(validator.strip(value));
        },
        tel: function(validator, $element, value) {
          if ($element.attr('type') !== 'tel' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.tel.test(validator.strip(value));
        },
        email: function(validator, $element, value) {
          if ($element.attr('type') !== 'email' || !('' + value).length) {
            return true;
          }
          return validator.config.pattern.email.test(validator.strip(value));
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
          return validator.config.pattern.decimal.test(validator.strip(value));
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
        min: function(validator, $element, value) {
          if (!$element.attr('min')) {
            return true;
          }
          return parseInt(value, 10) >= parseInt($element.attr('min'), 10);
        },
        max: function(validator, $element, value) {
          if (!$element.attr('max')) {
            return true;
          }
          return parseInt(value || 0, 10) <= parseInt($element.attr('max'), 10);
        },
        equal: function(validator, $element, value, context) {
          if (!$element.data('rule-is-equal-to')) {
            return true;
          }
          return value === $($element.data('rule-is-equal-to'), context).val();
        }
      },
      handler: {
        onReset: null,
        onValid: null,
        onInvalid: null,
        onGetValidMessage: function(validator, $element) {
          return $element.data("msg-valid");
        },
        onGetInvalidMessage: function(validator, $element, errors) {
          var error, message;
          error = errors[0];
          message = $element.data("msg-" + error.rule);
          return message || validator.messageFor(error.rule);
        },
        onBuildHint: function(validator, $element, result, message) {
          var classes, hintClass, validClass;
          classes = validator.config.classes;
          hintClass = classes.hint;
          validClass = result === true ? classes.valid : classes.invalid;
          return $("<label>", {
            "class": hintClass + ' ' + validClass,
            "for": $element.attr('id')
          }).html(message);
        },
        onShowHint: function(validator, $element, $newHint, $oldHint) {
          if ($oldHint == null) {
            $oldHint = null;
          }
          if ($newHint && $oldHint && $newHint.text() === $oldHint.text()) {
            $oldHint.replaceWith($newHint);
            return;
          }
          if ($newHint) {
            $newHint.hide().slideUp(1);
            if ($element.data('ivalidator-attach-hint-to')) {
              $($element.data('ivalidator-attach-hint-to')).append($newHint);
            } else {
              $element.after($newHint);
            }
          }
          if (!$oldHint) {
            if ($newHint) {
              $newHint.stop().slideDown(400);
            }
            return;
          }
          return $oldHint.stop().slideUp(400, function() {
            if ($newHint) {
              $newHint.stop().slideDown(400);
            }
            return $oldHint.remove();
          });
        },
        onShowHintForTesting: function(validator, $element, $newHint, $oldHint) {
          if ($oldHint == null) {
            $oldHint = null;
          }
          if ($newHint) {
            $element.after($newHint);
          }
          if ($oldHint) {
            return $oldHint.remove();
          }
        }
      }
    };

    function InputValidator(context1, config) {
      this.context = context1;
      if (config == null) {
        config = {};
      }
      this.onProcessHints = bind(this.onProcessHints, this);
      this.onInvalid = bind(this.onInvalid, this);
      this.onValid = bind(this.onValid, this);
      this.shouldBeValidated = bind(this.shouldBeValidated, this);
      this.isSingle = bind(this.isSingle, this);
      this.messageFor = bind(this.messageFor, this);
      this.elementsFor = bind(this.elementsFor, this);
      this.resetElement = bind(this.resetElement, this);
      this.reset = bind(this.reset, this);
      this.validateOne = bind(this.validateOne, this);
      this.validate = bind(this.validate, this);
      this.prepareElements = bind(this.prepareElements, this);
      this.init = bind(this.init, this);
      this.config = this.constructor.config;
      this.init(config, this.context);
      this.version = '1.1.11';
    }

    InputValidator.prototype.init = function(config, context) {
      if (context == null) {
        context = null;
      }
      if (config) {
        this.config = jQuery.extend(true, {}, this.config, config);
      }
      this.elementsSelector = this.config.selectors.elements;
      this.ns = 'ivalidator';
      return this.prepareElements(context);
    };

    InputValidator.prototype.strip = function(input) {
      var ret, x;
      ret = '';
      x = 0;
      while (x < input.length) {
        if (input.charCodeAt(x) >= 32 && input.charCodeAt(x) <= 255) {
          ret += input.charAt(x);
        }
        x++;
      }
      return ret;
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
      if (this.config.options.validateOnFocusOut) {
        $elements.off("focusout." + this.ns).on("focusout." + this.ns, (function(_this) {
          return function(e) {
            return _this.validateOne(e.target);
          };
        })(this));
      }
      if (this.config.options.removeHintOnFocus) {
        $elements.off("focus." + this.ns).on("focus." + this.ns, (function(_this) {
          return function(e) {
            return _this.resetElement(e.target);
          };
        })(this));
      }
      if (this.config.options.validateOnKeyUp) {
        $elements.off("keyup." + this.ns).on("keyup." + this.ns, (function(_this) {
          return function(e) {
            if ($(e.target).data('invalid')) {
              return _this.validateOne(e.target);
            }
          };
        })(this));
      }
      if (this.config.options.validateOnClick) {
        return $elements.off("click." + this.ns).on("click." + this.ns, (function(_this) {
          return function(e) {
            return _this.validateOne(e.target);
          };
        })(this));
      }
    };

    InputValidator.prototype.validate = function(context) {
      var $element, $elements, element, errors, i, len, offset, ref, result;
      if (context == null) {
        context = null;
      }
      errors = [];
      $elements = this.elementsFor(context);
      ref = $elements.get();
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        result = this.validateOne(element, context);
        if (result !== true) {
          errors = errors.concat(result);
        }
      }
      if (!errors.length) {
        return true;
      }
      if (this.config.options.focusOnInvalid) {
        $element = $elements.filter((function(_this) {
          return function(index, element) {
            return $(element).hasClass(_this.config.classes.invalid);
          };
        })(this)).first();
        $element.focus();
        if (this.config.options.scrollToOnInvalid) {
          offset = this.config.options.scrollToOnInvalidOffset;
          $('html, body').stop().animate({
            'scrollTop': $element.offset().top - offset
          });
        }
      }
      return errors;
    };

    InputValidator.prototype.validateOne = function(element, context) {
      var $element, errors, name, ref, ref1, rule, value;
      if (context == null) {
        context = this.context;
      }
      errors = [];
      $element = $(element);
      if ((ref = $element.attr('type')) === 'checkbox' || ref === 'radio') {
        name = $element.attr('name');
        value = $("[name='" + name + "']:checked", context).val();
      } else {
        value = $element.val();
      }
      ref1 = this.config.rules;
      for (name in ref1) {
        rule = ref1[name];
        if (!rule(this, $element, value, context)) {
          errors.push({
            element: $element,
            rule: name,
            value: value
          });
        }
      }
      if (errors.length === 0) {
        this.onValid($element);
        return true;
      }
      this.onInvalid($element, errors);
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
      var $element, base;
      $element = $(element);
      if (typeof (base = this.config.handler).onReset === "function") {
        base.onReset(this, $element);
      }
      $element.removeClass(this.config.classes.invalid + " " + this.config.classes.valid);
      $($element.data('ivalidator-hint')).remove();
      return $element.data('ivalidator-hint', null);
    };

    InputValidator.prototype.elementsFor = function(context) {
      if (context == null) {
        context = null;
      }
      if (context == null) {
        context = this.context;
      }
      if (this.isSingle(context)) {
        return $(context);
      }
      return $(this.elementsSelector, context).not(this.config.selectors.ignore);
    };

    InputValidator.prototype.messageFor = function(name) {
      var ref;
      if ((ref = this.config.messages) != null ? ref[name] : void 0) {
        return this.config.messages[name];
      }
      return this.config.messages.generic;
    };

    InputValidator.prototype.isSingle = function(input) {
      return $(input).is(this.elementsSelector);
    };

    InputValidator.prototype.shouldBeValidated = function(input) {
      return $(input).is(this.elementsSelector) && !$(input).is(this.ignoreSelector);
    };

    InputValidator.prototype.onValid = function($element) {
      var base;
      $element.data('invalid', false).data('errors', null).attr('aria-invalid', 'false').removeClass(this.config.classes.invalid).addClass(this.config.classes.valid);
      this.onProcessHints($element, true);
      return typeof (base = this.config.handler).onValid === "function" ? base.onValid(this, $element) : void 0;
    };

    InputValidator.prototype.onInvalid = function($element, errors) {
      var base;
      $element.data('invalid', true).data('errors', errors).attr('aria-invalid', 'true').removeClass(this.config.classes.valid).addClass(this.config.classes.invalid);
      this.onProcessHints($element, errors);
      return typeof (base = this.config.handler).onInvalid === "function" ? base.onInvalid(this, $element, errors) : void 0;
    };

    InputValidator.prototype.onProcessHints = function($element, result) {
      var $newHint, $oldHint, message;
      $oldHint = $element.data('ivalidator-hint');
      $newHint = null;
      if (result === true) {
        message = this.config.handler.onGetValidMessage(this, $element);
      } else {
        message = this.config.handler.onGetInvalidMessage(this, $element, result);
      }
      if (message) {
        $newHint = this.config.handler.onBuildHint(this, $element, result, message);
      }
      $element.data('ivalidator-hint', $newHint);
      return this.config.handler.onShowHint(this, $element, $newHint, $oldHint);
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
      instance = $this.data('ivalidator');
      if (!instance || config !== null) {
        $this.data('ivalidator', new InputValidator($this, config || {}));
        instance = $this.data('ivalidator');
      }
      return instance;
    };
  }

}).call(this);

//# sourceMappingURL=jquery.input.validator.js.map
