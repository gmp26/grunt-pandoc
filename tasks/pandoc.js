/**
 * pandoc compiling tasks
 *
 * Pandoc: http://johnmacfarlane.net/pandoc/
 * based on: https://github.com/Takazudo/gruntExamples
 *
 */
module.exports = function(grunt){
  
  var log = grunt.log;

  function handleResult(from, dest, err, stdout, code, done) {
    if(err){
      grunt.helper('growl', 'PANDOC COMPILING GOT ERROR', stdout);
      log.writeln(from + ': failed to compile to ' + dest + '.');
      log.writeln(stdout);
      done(false);
    }else{
      log.writeln(from + ': compiled to ' + dest + '.');
      //done(true);
    }
  }

  grunt.registerHelper('pandoc_file_to_dir', function(src, css, done) {

    var filename = src.replace(/^.*[\\\/]/, '');
    var base_name = filename.replace(/^.*\/|\.[^.]*$/g, '');
    var output_name = base_name + ".html";
    var output_path = src.replace(filename, output_name);

    var args = {
      cmd: 'pandoc',
      args: [ src, '-s', '-S', '-c', css, '--toc', '--mathjax', '-o', output_path]
    };

    grunt.helper('exec', args, function(err, stdout, code){
      handleResult(src, output_name, err, stdout, code, done);
    });

  });

  grunt.registerMultiTask('pandoc', 'compile markdown', function() {

    var done = this.async();
    var files = this.data.files;
    var css = this.data.css;


    var file_list = grunt.file.expandFiles(files);

    file_list.forEach(function (element, index, array) {
      grunt.helper('pandoc_file_to_dir', element, css, done);
    });

    // We're done!
    done(true);


  });

};