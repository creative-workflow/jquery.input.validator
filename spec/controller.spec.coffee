
describe 'jquery.input.validator', ->
  $ = jQuery
  validator = $('body').inputValidator()
  appendAndCallback = (content, callback) =>
    $content = $(content)
    $('body').append($content)
    callback($content)
    $content.remove()

  describe "config", ->

    describe "validateOnClick", ->
      it 'validates on click', ->
        elements = '<div>'
        elements+= '<input type="email" value="invalid.email">'
        elements+= '</div>'
        appendAndCallback(elements, ($elements) ->
          $elements.inputValidator({
            validateOnClick: true
          })

          $trigger = $('input', $elements)
          expect($trigger.hasClass(validator.config.classes.error)).toBe false
          $trigger.click()
          expect($trigger.hasClass(validator.config.classes.error)).toBe true
        )

  describe "validate", ->
    it 'validates valid given context', ->
      elements = '<div>'
      elements+= '<input type="email" value="tom@creative-workflow.berlin">'
      elements+= '<input type="number" value="42" required>'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        errors = $elements.inputValidator().validate()
        expect(errors.length).toBe 0
      )

    it 'validates invalid given context adhoc', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        errors = $elements.inputValidator().validate()
        expect(errors.length).toBe 2
      )


    it 'validates valid given context adhoc', ->
      elements = '<div>'
      elements+= '<input type="email" value="tom@creative-workflow.berlin">'
      elements+= '<input type="number" value="42" required>'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        errors = validator.validate($elements)
        expect(errors.length).toBe 0
      )

    it 'validates invalid given context adhoc', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        errors = validator.validate($elements)
        expect(errors.length).toBe 2
      )
