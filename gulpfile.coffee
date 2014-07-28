gulp = require('gulp')

gulp.task "deploy", ->
  deploy = require 'gulp-gh-pages'
  gulp.src "./dist/**/*"
    .pipe deploy {}
