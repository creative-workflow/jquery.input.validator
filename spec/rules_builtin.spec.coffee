describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').inputValidator()

  generateAndValidate = (element) ->
    validator.validateElement(
      helper.generateElement(element)
    )

  describe "validateElement", ->
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
