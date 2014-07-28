gulp = require "gulp"
gutil = require "gulp-util"
concat = require "gulp-concat"
uglify = require "gulp-uglify"

gulp.task "coffee", ->
  coffee = require "gulp-coffee"
  gulp.src "src/**/*.coffee"
    .pipe coffee {bare: true, print: true}
      .on "error", gutil.log
    .pipe concat "app.js"
    .pipe uglify()
    .pipe gulp.dest "dist/scripts"

gulp.task "deploy", ->
  deploy = require "gulp-gh-pages"
  gulp.src "./dist/**/*"
    .pipe deploy {}
