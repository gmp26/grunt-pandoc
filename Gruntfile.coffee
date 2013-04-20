# =================================
# do
#
# install growlnotify
#
# $ npm install
#
# Then...
# =================================
# $ grunt
# =================================

module.exports = (grunt) ->
  
  utils = (require './gruntcomponents/misc/commonutils')(grunt)
  grunt.task.loadTasks 'gruntcomponents/tasks'
  grunt.task.loadNpmTasks 'grunt-contrib-watch'

  grunt.initConfig

    pandoc:

      some_notes:
        files: 'some_notes/**/*.md'
        css: ['pandoc.css']



    watch:

      some_notes:
        files: 'some_notes/**/*.md'
        tasks: 'pandoc:some_notes'


  grunt.event.on 'pandoc.error', (msg) ->
    utils.growl 'ERROR!!', msg

  grunt.registerTask 'default', 'pandoc'

