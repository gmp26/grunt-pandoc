/**
 * grunt
 * based on: https://github.com/Takazudo/gruntExamples
 */
module.exports = function(grunt){

  grunt.initConfig({
    pandoc: {
      some_notes: {
        files: [ 'some_notes/**/*.md' ],
        css: ['pandoc.css']
      }
    },
    watch: {

      some_notes: {
        files: 'some_notes/**/*.md',
        tasks: 'pandoc:some_notes ok'
      }
    }
  });

  grunt.loadTasks('tasks');
  grunt.registerTask('default', 'pandoc ok');

};
