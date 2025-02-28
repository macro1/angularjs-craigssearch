gulp = require "gulp"
gutil = require "gulp-util"
concat = require "gulp-concat"
uglify = require "gulp-uglify"
runSequence = require "run-sequence"

gulp.task "jade", ->
  jade = require "gulp-jade"
  gulp.src "./src/**/*.jade"
    .pipe jade
        locals: {}
    .pipe gulp.dest "./dist"

gulp.task "coffee", ->
  coffee = require "gulp-coffee"
  gulp.src "./src/**/*.coffee"
    .pipe coffee {bare: true}
      .on "error", gutil.log
    .pipe concat "app.js"
    .pipe uglify()
    .pipe gulp.dest "./dist/scripts"

gulp.task "sass", ->
  sass = require("gulp-sass")(require "sass")
  gulp.src "./src/**/*.scss"
    .pipe sass()
      .on "error", gutil.log
    .pipe concat "app.css"
    .pipe gulp.dest "./dist/styles"

gulp.task "populate-cities", ->
  cityScraper = require "./cityScraper"
  cityScraper()

gulp.task "clean", ->
  clean = require "gulp-clean"
  gulp.src ["./dist/*", "!./dist/data"], read: false
    .pipe clean()

gulp.task "build", (callback) ->
  runSequence 'clean', ['jade', 'coffee', 'sass'], callback

gulp.task "deploy", ["build"], ->
  deploy = require "gulp-gh-pages"
  gulp.src "./dist/**/*"
    .pipe deploy {}
