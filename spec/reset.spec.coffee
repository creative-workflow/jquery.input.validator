
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

  describe "reset", ->
    it 'resets the validated elements', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        $elements.inputValidator()

        errors = $elements.inputValidator().validate()

        helper.expectInValid(errors)

        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe true
        $elements.inputValidator().reset()
        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe false
      )

    it 'resets the validated adhoc elements', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        errors = validator.validate($elements)

        helper.expectInValid(errors)

        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe true
        validator.reset($elements)
        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe false
      )

  describe "resetElement", ->
    it 'resets the validated elements', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        $element = $('input', $elements).first()
        errors = validator.validateElement($element)

        expect(errors.length).toBe 1

        expect($element.hasClass(validator.config.classes.error)).toBe true
        validator.resetElement($element)
        expect($element.hasClass(validator.config.classes.error)).toBe false
      )
