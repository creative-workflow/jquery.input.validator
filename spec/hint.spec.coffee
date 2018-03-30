
describe 'jquery.input.validator', ->
  $ = jQuery
  validator = $('body').inputValidator()
  appendAndCallback = (content, callback) =>
    $content = $(content)
    $('body').append($content)
    callback($content)
    $content.remove()

  describe "hint", ->
    it 'gets added to invalid inputs', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '<input type="number" value="" required>'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        $element = $('input', $elements).first()

        expect($(".#{validator.config.classes.hint}", $elements).length).toBe 0

        errors = validator.validateElement($element)

        expect(errors.length).toBe 1

        expect($(".#{validator.config.classes.hint}", $elements).length).toBe 1
      )

    it 'gets removed if input gets valid', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        expect($(".#{validator.config.classes.hint}", $elements).length).toBe 0

        errors = validator.validate($elements)
        expect($(".#{validator.config.classes.hint}", $elements).length).toBe 1

        validator.reset($elements)
        expect($(".#{validator.config.classes.hint}", $elements).length).toBe 0
      )

    it 'shows the default message', ->
      elements = '<div>'
      elements+= '<input type="email" value="tomcreative-workflow.berlin">'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        $element = $('input', $elements).first()

        errors = validator.validateElement($element)

        $label = $(".#{validator.config.classes.hint}", $elements)
        expect($label.length).toBe 1
        expect($label.text()).toBe validator.config.messages.email
      )

    it 'shows the data message', ->
      elements = '<div>'
      elements+= '<input type="email" data-msg-email="hint text" value="tomcreative-workflow.berlin">'
      elements+= '</div>'
      appendAndCallback(elements, ($elements) ->
        $element = $('input', $elements).first()

        errors = validator.validateElement($element)

        $label = $(".#{validator.config.classes.hint}", $elements)
        expect($label.length).toBe 1
        expect($label.text()).toBe 'hint text'
      )
