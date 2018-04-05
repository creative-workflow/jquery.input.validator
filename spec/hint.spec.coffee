
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator()

  hintSelector  = ".#{validator.config.classes.hint}"

  # override -> no waiting for dom changes
  validator.config.handler.onShowHint = validator.config.handler.onShowHintForTesting

  describe "hint", ->
    it 'gets added to invalid inputs', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        $element = $('input', $elements).first()

        expect($(hintSelector, $elements).length).toBe 0

        helper.expectInValid(validator.validateOne($element))

        expect($(hintSelector, $elements).length).toBe 1
      )

    describe "reset", ->
      it 'gets removed if input gets valid', ->
        helper.appendAndCallback(helper.invalidElements, ($elements) ->
          expect($(hintSelector, $elements).length).toBe 0

          validator.validate($elements)
          expect($(hintSelector, $elements).length).toBe 2

          validator.reset($elements)
          expect($(hintSelector, $elements).length).toBe 0
        )

    it 'shows the default message', ->
      helper.appendAndCallback(helper.invalidElements, ($elements) ->
        $input = $('input', $elements).first()

        validator.validateOne($input)

        $label = $(hintSelector, $elements)
        expect($label.length).toBe 1
        expect($label.text()).toBe validator.config.messages.email
      )

    it 'shows the data message', ->
      elements = [
        {type: 'email', value:'invalid', 'data-msg-email': 'hint text'}
      ]
      helper.appendAndCallback(elements, ($elements) ->
        $input = $('input', $elements).first()

        validator.validateOne($input)

        $label = $(hintSelector, $elements)
        expect($label.length).toBe 1
        expect($label.text()).toBe 'hint text'
      )


    it 'changes the message', ->
      elements = [
        {type: 'email', value:'ab', 'minlength': 3}
      ]

      helper.appendAndCallback(elements, ($elements) =>
        $element = $('input', $elements).first()

        validator.validateOne($element)

        $label = $(hintSelector, $elements)
        expect($label.text()).toBe validator.config.messages.minlength

        $element.val('not more minlength')
        validator.validateOne($element)

        $label = $(hintSelector, $elements)
        expect($label.text()).toBe validator.config.messages.email
      )

    it 'show valid message', ->
      elements = [
        {type: 'text', value:'ab', 'minlength': 3, 'data-msg-valid': 'OK!'}
      ]

      helper.appendAndCallback(elements, ($elements) =>
        $element = $('input', $elements).first()

        validator.validateOne($element)

        $label = $(hintSelector, $elements)
        expect($label.text()).toBe validator.config.messages.minlength

        $element.val('not more minlength')
        validator.validateOne($element)

        $label = $(hintSelector, $elements)
        expect($label.text()).toBe 'OK!'
      )
