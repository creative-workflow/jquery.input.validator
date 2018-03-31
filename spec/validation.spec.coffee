
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').inputValidator()

  describe "validate", ->
    describe "local pattern", ->
      it 'validates valid', ->
        helper.appendAndCallback(helper.validElements, ($elements) ->
          errors = $elements.inputValidator().validate()
          helper.expectValid(errors)
        )

      it 'validates invalid', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          errors = $elements.inputValidator().validate($elements)
          helper.expectInValid(errors)
        )

      it 'adds multiple errors', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          errors = $elements.inputValidator().validate($elements)
          expect(errors.length > 1).toBe true
        )

    describe "global pattern", ->
      it 'validates valid adhoc', ->
        helper.appendAndCallback(helper.validElements, ($elements) ->
          errors = validator.validate($elements)
          helper.expectValid(errors)
        )

      it 'validates invalid adhoc', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          errors = validator.validate($elements)
          helper.expectInValid(errors)
        )

    describe "validateOnClick", ->
      it 'triggers validation on click', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          $elements.inputValidator({
            validateOnClick: true
          })

          $trigger = $('input', $elements)
          expect($trigger.hasClass(validator.config.classes.error)).toBe false
          $trigger.click()
          expect($trigger.hasClass(validator.config.classes.error)).toBe true
        )
