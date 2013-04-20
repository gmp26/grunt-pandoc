module.exports = (grunt) ->
  
  log = grunt.log

  utils = (require '../misc/commonutils')(grunt)

  applyOptions = (cmd, options) ->
    #if options?.bare
    #  cmd = cmd.replace /^coffee/, 'coffee --bare'
    cmd

  createInvokeCommandCallbacks = (from, to, done) ->
    {
      onstdout: (output) ->
        log.writeln output
      onstderr: (output) ->
        log.writeln output
        grunt.event.emit 'coffee.error', output
      onsuccess: ->
        log.writeln "#{from}: compiled to #{to}"
        done true
      onfail: ->
        log.writeln "#{from}: failed compiling to #{to}"
        done false
    }



  pandoc_compile = (file, done, css, options) ->

    filename = file.replace(/^.*[\\\/]/, '')
    base_name = filename.replace(/^.*\/|\.[^.]*$/g, '')
    output_name = base_name + ".html"
    output_path = file.replace(filename, output_name)

    cmd = "pandoc #{file} -s -S -c #{css} --toc --mathjax -o #{output_path}"
    cmd = applyOptions cmd, options
    callbacks = createInvokeCommandCallbacks file, output_name, done
    utils.invokeCommand cmd, callbacks
    return @

  grunt.registerMultiTask "pandoc", "compile CoffeeScript files.", ->

    done = @async()
    files = @data.files
    dir = @data.dir
    css = @data.css
    options = @data.options or null
    
    # ex: [ '1.md', '2.md' ] -> 1.html, 2.html
    if files

      file_list = grunt.file.expand({filter: 'isFile'}, files)

      file_list.forEach (file, index, array) ->
        pandoc_compile file, done, css, options
      
    return @

