
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  invalidClass  = validator.config.classes.invalid

  describe "trigger", ->
    describe "validateOnClick", ->
      it 'doesnt triggers if disabled', ->
        element = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(element, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnClick: false
          })

          expect($input.hasClass(invalidClass)).toBe false
          $input.trigger('click')
          expect($input.hasClass(invalidClass)).toBe false
        )

      it 'triggers validation on click', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          $elements.iValidator({
            options:
              validateOnClick: true
          })

          $input = $('input', $elements)
          expect($input.hasClass(invalidClass)).toBe false
          $input.trigger('click')
          expect($input.hasClass(invalidClass)).toBe true
        )

    describe "validateOnKeyUp", ->
      it 'doesnt triggers if disabled', ->
        element = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(element, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnKeyUp: false
          })

          expect($input.hasClass(invalidClass)).toBe false
          $input.trigger('keyoup')
          expect($input.hasClass(invalidClass)).toBe false
        )

      it 'triggers validation on keyup if errord before', ->
        elements = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(elements, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnKeyUp: true
          })

          expect($input.hasClass(invalidClass)).toBe false
          $elements.iValidator().validate()
          expect($input.hasClass(invalidClass)).toBe true

          $input.val('123')
          expect($input.hasClass(invalidClass)).toBe true

          $input.trigger('keyup')
          expect($input.hasClass(invalidClass)).toBe false
        )

      it 'doesnt triggers validation on keyup if errord before', ->
        element = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(element, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnKeyUp: true
          })

          expect($input.hasClass(invalidClass)).toBe false
          $input.trigger('keyup')
          expect($input.hasClass(invalidClass)).toBe false
        )

    describe "validateOnFocusOut", ->
      it 'doesnt triggers if disabled', ->
        element = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(element, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnFocusOut: false
          })

          expect($input.hasClass(invalidClass)).toBe false
          $input.trigger('focusout')
          expect($input.hasClass(invalidClass)).toBe false
        )

      it 'triggers validation on keyup if errord before', ->
        elements = [
          {type: 'text', value: '1', minlength: 2}
        ]

        helper.appendAndCallback(elements, ($elements) ->
          $input = $('input', $elements)
          $elements.iValidator({
            options:
              validateOnFocusOut: true
          })

          expect($input.hasClass(invalidClass)).toBe false
          $elements.iValidator().validate()
          expect($input.hasClass(invalidClass)).toBe true

          $input.val('123')
          expect($input.hasClass(invalidClass)).toBe true

          $input.trigger('focusout')
          expect($input.hasClass(invalidClass)).toBe false
        )
