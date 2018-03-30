'use strict'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    includes:
      files:
        src: ['src/jquery.input.validator.coffee']
        dest: 'tmp'
        flatten: true
        cwd: '.'
        options:
          includeRegexp: /^(\s*)#=\s*include\s+(\S+)\s*$/
          silent: true
          banner: '# <% includes.files.dest %>'
    coffee:
      compile:
        files:
          'dist/jquery.input.validator.js': 'tmp/jquery.input.validator.coffee'
          'tmp/spec/rules.spec.js': 'spec/rules.spec.coffee'
          'tmp/spec/controller.spec.js': 'spec/controller.spec.coffee'
          'tmp/spec/reset.spec.js': 'spec/reset.spec.coffee'
          'tmp/spec/hint.spec.js': 'spec/hint.spec.coffee'
    coffeelint:
      app:
        [ 'src/*.coffee' ]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> v<%= pkg.version %> | <%= pkg.license %> */\n'
      build:
        files: 'dist/jquery.input.validator.min.js': 'dist/jquery.input.validator.js'
    jasmine:
      jquery1:
        src: 'dist/jquery.input.validator.js'
        options:
          specs: 'tmp/spec/*spec.js'
          vendor: [
            "bower_components/jquery-1/jquery.min.js"
            "bower_components/jasmine-jquery-legacy/lib/jasmine-jquery.js"
          ]
      jquery2:
        src: 'dist/jquery.input.validator.js'
        options:
          specs: 'tmp/spec/*spec.js'
          vendor: [
            "bower_components/jquery-2/dist/jquery.min.js"
            "bower_components/jasmine-jquery/lib/jasmine-jquery.js"
          ]
      jquery3:
        src: 'dist/jquery.input.validator.js'
        options:
          specs: 'tmp/spec/*spec.js'
          vendor: [
            "bower_components/jquery-3/dist/jquery.min.js"
            "bower_components/jasmine-jquery/lib/jasmine-jquery.js"
          ]
      jquery3Slim:
        src: 'dist/jquery.input.validator.js'
        options:
          specs: 'tmp/spec/*spec.js'
          vendor: [
            "bower_components/jquery-3/dist/jquery.slim.min.js"
            "bower_components/jasmine-jquery/lib/jasmine-jquery.js"
          ]
    watch:
      options: livereload: true
      files: '{src,spec}/*.coffee'
      tasks: 'default'

  # Loading dependencies
  for key of grunt.file.readJSON('package.json').devDependencies
    if key != 'grunt' and key.indexOf('grunt') == 0
      grunt.loadNpmTasks key

  grunt.registerTask 'default', [
    'includes'
    'coffeelint'
    'coffee'
    'jasmine'
    'uglify'
  ]

  grunt.registerTask 'lint', [
    'includes'
    'coffeelint'
  ]

  grunt.registerTask 'test', [
    'includes'
    'coffee'
    'jasmine:jquery3'
  ]
  
  grunt.registerTask 'test_all', [
    'includes'
    'coffee'
    'jasmine'
  ]
