'use strict'

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    git:
      add:
        options:
          simple:
            args: ['./dist']

      commit:
        options:
          message: 'dist v<%= pkg.version %>'

      push:
        options:
          simple:
            args: ['master']

      tag:
        options:
          simple:
            args: ['<%= pkg.version %>']

    replace:
      dist:
        options:
          patterns: [{
            match: /__VERSION__/
            replacement: '<%= pkg.version %>'
          }]
        files: [{
          expand: true
          flatten: true
          src: [
            'dist/**/*'
          ]
          dest: 'dist/'
        }]
      bower:
        options:
          patterns: [{
            match: /"version": "([^"]*)"/
            replacement: '"version": "<%= pkg.version %>"'
          }]
        files: [{
          expand: true
          flatten: true
          src: [
            'bower.json'
          ]
          dest: './'
        }]

    includes:
      files:
        src: ['src/jquery.input.validator.coffee']
        dest: 'build'
        flatten: true
        cwd: '.'
        options:
          includeRegexp: /^(\s*)#=\s*include\s+(\S+)\s*$/
          silent: true
          banner: '# <% includes.files.dest %>'

    coffee:
      dist:
        options:
          sourceMap: true
        files:
          'dist/jquery.input.validator.js': 'build/jquery.input.validator.coffee'
      specs:
        options:
          sourceMap: true
          flatten: false
          expand: false
        files:
          'build/spec/helper.js':          'spec/helper.coffee'
          'build/spec/controller.spec.js': 'spec/controller.spec.coffee'
          'build/spec/hint.spec.js':       'spec/hint.spec.coffee'
          'build/spec/reset.spec.js':      'spec/reset.spec.coffee'
          'build/spec/rules.spec.js':      'spec/rules.spec.coffee'

    coffeelint:
      app:
        [ 'src/*.coffee' ]

    uglify:
      options:
        banner: '/*! <%= pkg.name %> v<%= pkg.version %> | <%= pkg.license %> */\n'
      build:
        files: 'dist/jquery.input.validator.min.js': 'dist/jquery.input.validator.js'

    exec:
      npm_publish: 'npm publish'

    clean:
      build: 'build'
      dist:  'dist'

    jasmine:
      jquery1:
        src: 'dist/jquery.input.validator.js'
        options:
          specs:   'build/spec/*spec.js'
          helpers: 'build/spec/*helper.js'
          vendor: [
            "bower_components/jquery-1/jquery.min.js"
            "bower_components/jasmine-jquery-legacy/lib/jasmine-jquery.js"
          ]
      jquery2:
        src: 'dist/jquery.input.validator.js'
        options:
          specs:   'build/spec/*spec.js'
          helpers: 'build/spec/*helper.js'
          vendor: [
            "bower_components/jquery-2/dist/jquery.min.js"
            "bower_components/jasmine-jquery/lib/jasmine-jquery.js"
          ]
      jquery3:
        src: 'dist/jquery.input.validator.js'
        options:
          specs:   'build/spec/*spec.js'
          helpers: 'build/spec/*helper.js'
          vendor: [
            "bower_components/jquery-3/dist/jquery.min.js"
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

  grunt.registerTask 'code', [ 'clean', 'includes', 'coffee', 'replace:dist', 'replace:bower' ]

  grunt.registerTask 'lint', [ 'includes', 'coffeelint' ]

  grunt.registerTask 'test',     [ 'code', 'jasmine:jquery3' ]
  grunt.registerTask 'test-all', [ 'code', 'jasmine'         ]

  grunt.registerTask 'build', [ 'code', 'lint', 'test-all', 'uglify' ]

  grunt.registerTask 'git-push-dist', [ 'git:add', 'git:commit', 'git:tag', 'git:push' ]

  # the version is comes from package.json:version
  grunt.registerTask 'release', [ 'build', 'git-push-dist', 'exec:npm_publish' ]

  grunt.registerTask 'default', [ 'build' ]
