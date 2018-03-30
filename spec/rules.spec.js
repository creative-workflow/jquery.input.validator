(function() {
  describe('jquery.input.validator', function() {
    var $, validator;
    $ = jQuery;
    validator = $('body').inputValidator();
    return describe("validateElement", function() {
      return describe("rules", function() {
        describe("email", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="email" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="email" value="tom@creative-workflow.berlin">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="email" value="invalid.email">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        describe("tel", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="tel" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="tel" value="+49 (30) / 443322">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="tel" value="invalid.phone">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        describe("number", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="number" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="number" value="12">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
        });
        describe("required", function() {
          it('succeeds without attribute', function() {
            var element, errors;
            element = $('<input type="text" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('fails with empty input', function() {
            var element, errors;
            element = $('<input type="text" value="" required>');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
          return it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="text" value="abc" required>');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
        });
        describe("maxlength", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="text" maxlength="3" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="text" maxlength="3" value="abc">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="text" maxlength="3" value="abcd">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        describe("minlength", function() {
          it('fails with empty input', function() {
            var element, errors;
            element = $('<input type="text" minlength="3" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="text" minlength="3" value="abc">');
            errors = validator.validateElement(element);
            expect(errors.length).toBe(0);
            element = $('<input type="text" minlength="3" value="abcd">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="text" minlength="3" value="ab">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        describe("pattern", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="text" pattern="^\\d*$" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="text" pattern="^\\d*$" value="123">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="text" pattern="^\\d*$" value="12a">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        describe("hasClass", function() {
          it('succeeds with valid class', function() {
            var element, errors;
            element = $('<input type="text" data-rule-has-class="class" class="class">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid class', function() {
            var element, errors;
            element = $('<input type="text" data-rule-has-class="class" class="">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
        return describe("decimal", function() {
          it('succeeds with empty input', function() {
            var element, errors;
            element = $('<input type="text" data-rule-decimal="true" value="">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          it('succeeds with valid input', function() {
            var element, errors;
            element = $('<input type="text" data-rule-decimal="true" value="12.2">');
            errors = validator.validateElement(element);
            expect(errors.length).toBe(0);
            element = $('<input type="text" data-rule-decimal="true" value="12">');
            errors = validator.validateElement(element);
            return expect(errors.length).toBe(0);
          });
          return it('fails with invalid input', function() {
            var element, errors;
            element = $('<input type="text" data-rule-decimal="true" value="12g">');
            errors = validator.validateElement(element);
            return expect(errors.length > 0).toBe(true);
          });
        });
      });
    });
  });

}).call(this);
