helper = jasmine.helper = jasmine.helper || {}


helper.appendAndCallback = (content, callback) ->
  if typeof(content) != 'string'
    $content = helper.generateElements(content)
  else
    $content = $(content)

  $('body').append($content)
  callback($content)
  $content.remove()

helper.expectValid = (errors) ->
  expect(errors.length == 0).toBe true

helper.expectInValid = (errors) ->
  expect(errors.length == 0).toBe false

helper.generateElement = (definition) ->
  $("<#{definition.tag || 'input'}/>", definition)

helper.generateElements = (definitions) ->
  root = $('<div class="wrapper"></div>')
  for definition in definitions
    root.append(helper.generateElement(definition))

  root

helper.printHtml = (element) ->
  console.log $(element).wrapAll('<div>').parent().html()
