
describe 'jquery.input.validator', ->
  $ = jQuery
  validator = $('body').inputValidator()
  appendAndCallback = (content, callback) =>
    $content = $(content)
    $('body').append($content)
    callback($content)
    $content.remove()

  describe "reset", ->
    it 'resets the validated elements', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'

      appendAndCallback(elements, ($elements) ->
        $elements.inputValidator()

        errors = $elements.inputValidator().validate()

        expect(errors.length).toBe 2

        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe true
        $elements.inputValidator().reset()
        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe false
      )

    it 'resets the validated adhoc elements', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'

      appendAndCallback(elements, ($elements) ->
        errors = validator.validate($elements)

        expect(errors.length).toBe 2

        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe true
        validator.reset($elements)
        expect($('input', $elements).hasClass(validator.config.classes.error)).toBe false
      )

  describe "resetElement", ->
    it 'resets the validated elements', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'

      appendAndCallback(elements, ($elements) ->
        $element = $('input', $elements).first()
        errors = validator.validateElement($element)

        expect(errors.length).toBe 1

        expect($element.hasClass(validator.config.classes.error)).toBe true
        validator.resetElement($element)
        expect($element.hasClass(validator.config.classes.error)).toBe false
      )
