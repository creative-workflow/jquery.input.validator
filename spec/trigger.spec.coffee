
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  describe "trigger", ->
    describe "validateOnClick", ->
      it 'triggers validation on click', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          $elements.iValidator({
            validateOnClick: true
          })

          $trigger = $('input', $elements)
          expect($trigger.hasClass(validator.config.classes.error)).toBe false
          $trigger.click()
          expect($trigger.hasClass(validator.config.classes.error)).toBe true
        )
