steroids = require "../../../steroids"
spawn = require("child_process").spawn
path = require "path"
fs = require "fs"
ejs = require "ejs"
util = require "util"

Base = require "../Base"
Help = require "../../Help"

class Animation extends Base
  @usageParams: ->
    "<name>"

  @usage: ()->
    """
    Generates an example of native animations.

    Options:
      - name: name of the folder to create. Example: 'animationExample' will result in the following files:
        - app/layouts/animationExample.html
        - app/views/animationExample/index.html
    """

  templatePath: ->
    path.join(steroids.paths.templates.resources, "animation")

  generate: ->
    @checkForPreExistingFiles [
      path.join("app", "layouts", "#{@options.name}.html"),
      path.join("app", "views", "#{@options.name}", "index.html"),
      path.join("app", "views", "#{@options.name}", "show.html")
    ]

    @ensureDirectory path.join("app")
    @ensureDirectory path.join("app", "views")
    @ensureDirectory path.join("app", "views", @options.name)
    @ensureDirectory path.join("app", "views", "layouts")

    @copyFile path.join("app", "views", "layouts", "#{@options.name}.html"), "layout.html.template"
    @addFile path.join("app", "views", @options.name, "index.html"), "index.html.template"

    Help.SUCCESS()
    console.log """

    Command completed successfully, now set the location of your app to:

      http://localhost/views/#{@options.name}/index.html

    """

module.exports = Animation