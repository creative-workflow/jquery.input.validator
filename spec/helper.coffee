helper = jasmine.helper = jasmine.helper || {}

helper.printJqueryVersion = ->
  console.log "jQuery.version: #{$.fn.jquery} \n\n"

helper.printJqueryVersion()

helper.validElements = [
  {type: 'email' , value: 'tom@creative-workflow.berlin' },
  {type: 'number', value: 42, required: true}
]

helper.invalidElements = [
  {type: 'email' , value: 'tomcreative-workflow.berlin' },
  {type: 'number', required: true}
]

helper.appendAndCallback = (content, callback) ->
  if typeof(content) != 'string'
    $content = helper.generateElements(content)
  else
    $content = $(content)

  $('body').append($content)
  callback($content)
  $content.remove()

helper.expectValid = (result) ->
  expect(result).toBe true

helper.expectInValid = (result) ->
  expect(result).not.toBe true

helper.generateElement = (definition) ->
  $("<#{definition.tag || 'input'}/>", definition)

helper.generateElements = (definitions) ->
  root = $('<div class="wrapper"></div>')
  for definition in definitions
    root.append(helper.generateElement(definition))

  root

helper.printHtml = (element) ->
  console.log $(element).wrapAll('<div>').parent().html()

helper.waitsForAndRuns = (escapeFunction, runFunction, escapeTime=3000) ->
  interval = setInterval((->
    if escapeFunction()
      clearMe()
      runFunction()
  ), 100)

  timeOut = setTimeout((->
    clearMe()
    runFunction()
  ), escapeTime)

  clearMe = ->
    expect('waitsForAndRuns').toBe 'timed out'
    clearInterval interval
    clearTimeout timeOut
