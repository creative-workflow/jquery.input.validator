
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  describe "validate", ->
    it 'returns true on valid', ->
      helper.appendAndCallback(helper.validElements, ($elements) ->
        result = $elements.iValidator().validate()
        expect(result).toBe true
      )

    it 'returns array of erros on invalid', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        result = $elements.iValidator().validate()
        expect(result.length > 0).toBe true
      )

    describe "local pattern", ->
      it 'validates valid', ->
        helper.appendAndCallback(helper.validElements, ($elements) ->
          result = $elements.iValidator().validate()
          helper.expectValid(result)
        )

      it 'validates invalid', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          result = $elements.iValidator().validate($elements)
          helper.expectInValid(result)
        )

      it 'adds multiple result', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          result = $elements.iValidator().validate($elements)
          expect(result.length > 1).toBe true
        )

    describe "global pattern", ->
      it 'validates valid', ->
        helper.appendAndCallback(helper.validElements, ($elements) ->
          result = validator.validate($elements)
          helper.expectValid(result)
        )

      it 'validates invalid', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          result = validator.validate($elements)
          helper.expectInValid(result)
        )
