gulp = require 'gulp'

bower       = require 'main-bower-files'
filter      = require 'gulp-filter'
coffee      = require 'gulp-coffee'
sass        = require 'gulp-sass'
concat      = require 'gulp-concat'
rimraf      = require 'rimraf'
runSequence = require 'run-sequence'
webserver   = require 'gulp-webserver'

path =
  coffee: './src/**/*.coffee'
  scss:   './src/**/*.scss'
  src:    './src/'
  dist:   './dist/'

gulp.task 'default', ->
  runSequence 'sequence'

gulp.task 'autoreload', ['webserver', 'watch-script', 'watch-style', 'watch-resource']

gulp.task 'sequence', ->
  runSequence 'clean', 'build', 'deploy', ->

gulp.task 'clean', ->
  rimraf path.dist, ->

gulp.task 'build', ['bower-js', 'compile-coffee', 'compile-scss']

gulp.task 'deploy', ['copy']

gulp.task 'watch-script', ->
  gulp.watch path.coffee, ['compile-coffee']

gulp.task 'watch-style', ->
  gulp.watch path.scss, ['compile-scss']

gulp.task 'watch-resource', ->
  gulp.watch ['./src/**/*.html', './src/**/*.png'], ['copy']

gulp.task 'webserver', ->
  gulp.src './dist/'
    .pipe webserver(
      livereload: true
      port: 8080
      fallback: 'index.html'
      open: true
    )

gulp.task 'bower-js', ->
  jsCssFilter = filter ['**/*.js', '**/*.css']
  gulp.src bower()
    .pipe jsCssFilter
    .pipe gulp.dest(path.dist)

gulp.task 'compile-coffee', ->
  gulp.src path.coffee
    .pipe coffee()
    .pipe gulp.dest(path.dist)

gulp.task 'compile-scss', ->
  gulp.src path.scss
    .pipe sass()
    .pipe gulp.dest(path.dist)

gulp.task 'copy', ->
  gulp.src ['./src/**/*.html', './src/**/*.png'], base: path.src
    .pipe gulp.dest(path.dist)
