
describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').inputValidator()

  hintSelector  = ".#{validator.config.classes.hint}"

  validElements = [
    {type: 'email' , value: 'tom@creative-workflow.berlin' },
    {type: 'number', value: 42, required: true}
  ]

  invalidElements = [
    {type: 'email' , value: 'tomcreative-workflow.berlin' },
    {type: 'number', required: true}
  ]

  describe "hint", ->
    it 'gets added to invalid inputs', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        $element = $('input', $elements).first()

        expect($(hintSelector, $elements).length).toBe 0

        helper.expectInValid(validator.validateElement($element))

        expect($(hintSelector, $elements).length).toBe 1
      )

    describe "reset", ->
      it 'gets removed if input gets valid', ->
        helper.appendAndCallback(invalidElements, ($elements) ->
          expect($(hintSelector, $elements).length).toBe 0

          validator.validate($elements)
          expect($(hintSelector, $elements).length).toBe 2

          validator.reset($elements)
          expect($(hintSelector, $elements).length).toBe 0
        )

    it 'shows the default message', ->
      helper.appendAndCallback(invalidElements, ($elements) ->
        $input = $('input', $elements).first()

        validator.validateElement($input)

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

        validator.validateElement($input)

        $label = $(hintSelector, $elements)
        expect($label.length).toBe 1
        expect($label.text()).toBe 'hint text'
      )

    it 'changes the message', ->
      elements = [
        {type: 'email', value:'ab', 'minlength': 3}
      ]
      helper.appendAndCallback(elements, ($elements) ->
        $element = $('input', $elements).first()

        validator.validateElement($element)

        $label = $(hintSelector, $elements)
        expect($label.text()).toBe validator.config.messages.minlength

        $element.val('not more minlength')
        validator.validateElement($element)
        expect($label.text()).toBe validator.config.messages.email
      )
