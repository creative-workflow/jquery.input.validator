describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  generateAndValidate = (element) ->
    validator.validateOne(
      helper.generateElement(element)
    )

  describe "validateOne", ->
    describe "rules", ->

      describe "email", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'email' }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'email', value: 'tom@creative-workflow.berlin' }
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'email', value: 'invalid.email' }
          )

      describe "tel", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'tel' }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'tel', value: '+49 (30) / 443322' }
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'tel', value: 'invalid.phone' }
          )

      describe "number", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'number' }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'number', value: '12' }
          )

        describe "max", ->
          it 'succeeds with empty input', ->
            helper.expectValid generateAndValidate(
              { type: 'number', max: '12' }
            )

          it 'succeeds with valid input', ->
            helper.expectValid generateAndValidate(
              { type: 'number', value: '12', max: '12' }
            )

            helper.expectValid generateAndValidate(
              { type: 'number', value: '12', max: '13' }
            )

          it 'fails with invalid input', ->
            helper.expectInValid generateAndValidate(
              { type: 'number', value: '13', max: '12' }
            )

        describe "min", ->
          it 'fails with empty input', ->
            helper.expectInValid generateAndValidate(
              { type: 'number', min: '3' }
            )

          it 'succeeds with valid input', ->
            helper.expectValid generateAndValidate(
              { type: 'number', value: '12', min: '12' }
            )
            helper.expectValid generateAndValidate(
              { type: 'number', value: '12', min: '11' }
            )

          it 'fails with invalid input', ->
            helper.expectInValid generateAndValidate(
              { type: 'number', value: '11', min: '12' }
            )

        # some browser passing empty string when invalid input for type number
        # it 'fails with invalid input', ->
        #


      describe "required", ->
        it 'succeeds without attribute', ->
          helper.expectValid generateAndValidate(
            { type: 'text' }
          )

        it 'fails with empty input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', required: true}
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: 'abc', required: true}
          )

      describe "maxlength", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: '3', maxlength: '3' }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: 'abc', maxlength: '3' }
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', value: 'abcd', maxlength: '3' }
          )

      describe "minlength", ->
        it 'fails with empty input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', minlength: '3' }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: 'abc', minlength: '3' }
          )
          helper.expectValid generateAndValidate(
            { type: 'text', value: 'abcd', minlength: '3' }
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', value: 'av', minlength: '3' }
          )

      describe "pattern", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', pattern:"^\\d*$" }
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: '123', pattern:"^\\d*$" }
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', value: '12a', pattern:"^\\d*$" }
          )

      describe "hasClass", ->
        it 'succeeds with valid class', ->
          helper.expectValid generateAndValidate(
            { type: 'text', class: 'class', 'data-rule-has-class': 'class' }
          )

        it 'fails with invalid class', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', 'data-rule-has-class': 'class' }
          )

      describe "decimal", ->
        it 'succeeds with empty input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', 'data-rule-decimal': true}
          )

        it 'succeeds with valid input', ->
          helper.expectValid generateAndValidate(
            { type: 'text', value: '12.2', 'data-rule-decimal': true}
          )
          helper.expectValid generateAndValidate(
            { type: 'text', value: '12', 'data-rule-decimal': true}
          )

        it 'fails with invalid input', ->
          helper.expectInValid generateAndValidate(
            { type: 'text', value: '12g', 'data-rule-decimal': true}
          )

      describe "equal", ->
        it 'fails with unequal input', ->
          p1 = helper.generateElement(
            {type: 'password', value: 42, required: true, class: 'password1'}
          )
          p2 = helper.generateElement(
            {type: 'password', value: 41, required: true, class: 'password2', 'data-rule-is-equal-to':'.password1'}
          )

          div = $('<div\>').append($('<div\>').append(p1).append(p2))

          equalValidator = new InputValidator(div, {})
          helper.expectInValid(
            equalValidator.validateOne(p2, div)
          )

        it 'succeeds with equal input', ->
          p1 = helper.generateElement(
            {type: 'password', value: 42, required: true, class: 'password1'}
          )
          p2 = helper.generateElement(
            {type: 'password', value: 42, required: true, class: 'password2', 'data-rule-is-equal-to':'.password1'}
          )

          div = $('<div\>').append($('<div\>').append(p1).append(p2))

          equalValidator = new InputValidator(div, {})
          helper.expectValid(
            equalValidator.validateOne(p2, div)
          )
