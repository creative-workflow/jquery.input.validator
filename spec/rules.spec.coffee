
describe 'jquery.input.validator', ->
  $ = jQuery
  validator = $('body').inputValidator()

  describe "validateElement", ->
    describe "rules", ->
      describe "email", ->
        it 'succeeds with empty input', ->
          element = '<input type="email" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="email" value="tom@creative-workflow.berlin">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="email" value="invalid.email">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "tel", ->
        it 'succeeds with empty input', ->
          element = '<input type="tel" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="tel" value="+49 (30) / 443322">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="tel" value="invalid.phone">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "number", ->
        it 'succeeds with empty input', ->
          element = '<input type="number" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="number" value="12">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        # some browser passing empty string when invalid input for type number
        # it 'fails with invalid input', ->
        #   element = '<input type="number" value="abc">'
        #   $(element).attr('value', 'abc')
        #   errors  = validator.validateElement(element)
        #   expect(errors.length > 0).toBe true

      describe "required", ->
        it 'succeeds without attribute', ->
          element = '<input type="text" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with empty input', ->
          element = '<input type="text" value="" required>'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

        it 'succeeds with valid input', ->
          element = '<input type="text" value="abc" required>'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

      describe "maxlength", ->
        it 'succeeds with empty input', ->
          element = '<input type="text" maxlength="3" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="text" maxlength="3" value="abc">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="text" maxlength="3" value="abcd">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "minlength", ->
        it 'fails with empty input', ->
          element = '<input type="text" minlength="3" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

        it 'succeeds with valid input', ->
          element = '<input type="text" minlength="3" value="abc">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

          element = '<input type="text" minlength="3" value="abcd">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="text" minlength="3" value="ab">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "pattern", ->
        it 'succeeds with empty input', ->
          element = '<input type="text" pattern="^\\d*$" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="text" pattern="^\\d*$" value="123">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="text" pattern="^\\d*$" value="12a">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "hasClass", ->
        it 'succeeds with valid class', ->
          element = '<input type="text" data-rule-has-class="class" class="class">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid class', ->
          element = '<input type="text" data-rule-has-class="class" class="">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true

      describe "decimal", ->
        it 'succeeds with empty input', ->
          element = '<input type="text" data-rule-decimal="true" value="">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'succeeds with valid input', ->
          element = '<input type="text" data-rule-decimal="true" value="12.2">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

          element = '<input type="text" data-rule-decimal="true" value="12">'
          errors  = validator.validateElement(element)
          expect(errors.length).toBe 0

        it 'fails with invalid input', ->
          element = '<input type="text" data-rule-decimal="true" value="12g">'
          errors  = validator.validateElement(element)
          expect(errors.length > 0).toBe true
