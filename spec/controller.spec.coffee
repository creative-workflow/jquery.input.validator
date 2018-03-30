
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').inputValidator()

  validElements = [
    {type: 'email' , value: 'tom@creative-workflow.berlin' },
    {type: 'number', value: 42, required: true}
  ]

  invalidElements = [
    {type: 'email' , value: 'tomcreative-workflow.berlin' },
    {type: 'number', required: true}
  ]

  describe "config", ->

    describe "validateOnClick", ->
      it 'validates on click', ->
        helper.appendAndCallback(invalidElements, ($elements) ->
          $elements.inputValidator({
            validateOnClick: true
          })

          $trigger = $('input', $elements)
          expect($trigger.hasClass(validator.config.classes.error)).toBe false
          $trigger.click()
          expect($trigger.hasClass(validator.config.classes.error)).toBe true
        )

  describe "validate", ->
    it 'validates valid given context', ->
      helper.appendAndCallback(validElements, ($elements) ->
        errors = $elements.inputValidator().validate()
        helper.expectValid(errors)
      )

    it 'validates invalid given context', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        errors = $elements.inputValidator().validate($elements)
        expect(errors.length).toBe 2
      )

    it 'validates valid given context adhoc', ->
      helper.appendAndCallback(validElements, ($elements) ->
        errors = validator.validate($elements)
        helper.expectValid(errors)
      )

    it 'validates invalid given context adhoc', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        errors = validator.validate($elements)
        helper.expectInValid(errors)
      )
