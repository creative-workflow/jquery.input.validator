
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  invalidClass  = validator.config.classes.invalid

  describe "reset", ->
    it 'resets the validated elements', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        $elements.iValidator()

        result = $elements.iValidator().validate()

        helper.expectInValid(result)

        expect($('input', $elements).hasClass(invalidClass)).toBe true
        $elements.iValidator().reset()
        expect($('input', $elements).hasClass(invalidClass)).toBe false
      )

    it 'resets the validated adhoc elements', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        result = validator.validate($elements)

        helper.expectInValid(result)

        expect($('input', $elements).hasClass(invalidClass)).toBe true
        validator.reset($elements)
        expect($('input', $elements).hasClass(invalidClass)).toBe false
      )

  describe "resetElement", ->
    it 'resets the validated elements', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        $element = $('input', $elements).first()

        result = validator.validateOne($element)
        helper.expectInValid(result)

        expect($element.hasClass(invalidClass)).toBe true
        validator.resetElement($element)
        expect($element.hasClass(invalidClass)).toBe false
      )
