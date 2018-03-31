describe 'jquery.input.validator', ->
  $         = jQuery
  helper    = jasmine.helper
  validator = $('body').iValidator({
    rules:
      helloWorld: (validator, $element, value) ->
        return true unless $element.data('rule-hello-world')
        value == $element.data('rule-hello-world')

    messages:
      helloWorld: 'this is not "hello world"'
  })

  hintSelector  = ".#{validator.config.classes.hint}"

  generateAndValidate = (element) ->
    validator.validateOne(
      helper.generateElement(element)
    )

  describe "rules", ->
    describe "add cutom rule", ->
      it 'validates valid', ->
        helper.expectValid generateAndValidate(
            { type: 'text', 'data-rule-hello-world': 'hello world', value: 'hello world'}
        )

      it 'validates invalid', ->
        helper.expectInValid generateAndValidate(
            { type: 'text', 'data-rule-hello-world': 'hello world', value: 'not hello world'}
        )

      it 'has the correct message', ->
        elements = [
          { type: 'text', 'data-rule-hello-world': 'hello world', value: 'not hello world'}
        ]
        helper.appendAndCallback(elements, ($elements) ->
          $input = $('input', $elements).first()

          validator.validateOne($input)

          $label = $(hintSelector, $elements)
          expect($label.length).toBe 1
          expect($label.text()).toBe 'this is not "hello world"'
        )

      it 'doens not override default rules', ->
        helper.expectInValid generateAndValidate(
          { type: 'text', required: true}
        )
