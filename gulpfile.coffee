##############################
# user variables
##############################

# 注）ディレクトリ指定は"/"で終わること

SRC       = "./src/"
DEST      = "./dest/"
DEST_SUB  = "" # 不要な場合は ""
RESRC_SUB= "" # 不要な場合は ""

convertTo = "utf-8" # 出力ソースの文字コード (utf-8|cp932|euc-jp)から選択 *cp932(shift_jisの拡張)

## 変換先の指定
DEST_HTML     = "#{DEST}#{DEST_SUB}"
DEST_JS       = "#{DEST}#{DEST_SUB}js/#{RESRC_SUB}"
DEST_CSS      = "#{DEST}#{DEST_SUB}css/#{RESRC_SUB}"
IMG           = "#{DEST_SUB}img/#{RESRC_SUB}"
DEST_IMG      = "#{DEST}#{IMG}"
## 変換先の指定
SRC_JS        = "#{SRC}js/#{RESRC_SUB}"
SRC_CSS       = "#{SRC}css/#{RESRC_SUB}"
SRC_IMG       = "#{SRC}img/#{RESRC_SUB}"
###############################

# console.log "#{DEST_JS}"
# console.log "#{DEST_CSS}"
# console.log "#{IMG}"
# console.log "#{DEST_IMG}"
# console.log "#{SRC_JS}"
# console.log "#{SRC_CSS}"
# console.log "#{SRC_IMG}"

# ファイルタイプごとに無視するファイルなどを設定
## ファイル名の拡張子を変更する、もしくは前に_(アンダーバー)をつけると除外させる設定
paths =
  js:     ["#{SRC_JS}**/*.coffee" , "!#{SRC_JS}**/_**/*.coffee" , "!#{SRC_JS}**/_*.coffee"]
  css:    ["#{SRC_CSS}**/*.styl"  , "!#{SRC_CSS}**/_**/*.styl"  , "!#{SRC_CSS}**/_*.styl", "!#{SRC_CSS}**/sprite*.styl"]
  cssw:   ["#{SRC_CSS}**/*.styl"  ,  "#{SRC_CSS}**/_**/*.styl"  , "!#{SRC_CSS}**/_*.styl"]
  img:    ["#{SRC_IMG}**/*.{png, jpg, gif}", "!#{SRC_IMG}**/sprite/**/*.png"]
  html:   ["#{SRC}**/*.jade", "!#{SRC}**/_**/*.jade", "!#{SRC}**/_*.jade"]
  # sprite: ["#{SRC}**/sprite/**/*.png"]
  sprite: ["#{SRC_IMG}**/sprite/icon_*.png"] # icon_*.png縛り

isWin     = true # Windowsか否

# _               = require 'underscore'
gulp            = require 'gulp'
# os              = require 'os'
# jade            = require 'gulp-jade'
# stylus          = require 'gulp-stylus'
# nib             = require 'nib'                        # FW for Stylus
# rename          = require 'gulp-rename'                # ファイル名変更
imagemin        = require 'gulp-imagemin'              # 画像最適化
# browserify      = require 'gulp-browserify'            # ファイル分割
# spritesmith     = require 'gulp.spritesmith'           # sprite画像作成 ファイル名は半角英数記号（ピリオド・アンダーバー）
# convertEncoding = require 'gulp-convert-encoding'      # 文字コード変更
util            = require 'gulp-util'
# plumber         = require 'gulp-plumber'               # エラーがあってもwatchを継続させる
pngquant        = require 'imagemin-pngquant'          # png圧縮の為のオプティマイザ
mkdirp          = require 'mkdirp'                     # フォルダ作成
# pleeease        = require "gulp-pleeease"              # ベンダープレフィックスを自動補完
# cmq             = require "gulp-combine-media-queries" # メディアクエリの整理
# hologram        = require 'gulp-hologram'              # スタイルガイドジェネレーター
#kss             = require 'gulp-kss'                   # スタイルガイドジェネレーター
# notify          = require 'gulp-notify'                # デスクトップ通知 for Mac
# .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')}) # <-- mac
# .pipe plumber({ errorHandler: handleError})                            # <-- windows

# expand = (ext)-> rename (path) -> _.tap path, (p) -> p.extname = ".#{ext}"

# isWindows = ->
#   if os.platform().match('win') != null
#     isWin = false
#   return isWin

# handleError = (err)->
#   if (err)
#     util.log err.message
#   else
#     util.log 'handleError!'
#   return

dirMk = (err)->
  if (err)
    util.log err
  else
    util.log 'dirMk!'

# gulp.task "jade", ->
#   gulp.src paths.html
#     .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')})
#     .pipe jade pretty: true, basedir: 'src/'
#     .pipe expand "html"
#     .pipe convertEncoding({to: convertTo})
#     .pipe gulp.dest "#{DEST_HTML}"
#
# gulp.task 'browserify', ->
#   gulp.src paths.js, read: false
#     .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')})
#     .pipe browserify
#         debug: false
#         transform: ['coffeeify', 'jadeify', 'stylify', 'debowerify']
#         extensions: ['.coffee'],
#     .pipe expand "js"
#     .pipe gulp.dest "#{DEST_JS}"
#
# gulp.task "stylus", ["sprite"], ->
#   gulp.src paths.css
#     .pipe plumber({ errorHandler: notify.onError('<%= error.message %>')})
#     .pipe stylus use: nib(), errors: true
#     .pipe pleeease({
#         minifier: false,
#         fallbacks: {
#             autoprefixer: ['last 4 versions'] #ベンダープレフィックス
#         },
#     })
#     .pipe expand "css"
#     .pipe gulp.dest "#{DEST_CSS}"

# 画像の最適化、データサイズの圧縮
gulp.task "imagemin", ->
  gulp.src paths.img
    .pipe(imagemin({
          progressive: true,
          svgoPlugins: [{removeViewBox: false}],
          use: [pngquant()]
      }))
    .pipe gulp.dest "#{DEST_IMG}"

# gulp.task "sprite", ->
#   a = gulp.src paths.sprite
#     .pipe spritesmith
#       imgName: "sprite.png"                       # 生成されるpng
#       cssName: "sprite.styl"                      # 生成されるstyl
#       imgPath: "/#{IMG}sprite.png"     # 生成されるstylに記載されるパス
#       algorithm: "binary-tree"
#       cssFormat: "stylus"
#       padding: 4
#   a.img.pipe gulp.dest "#{SRC_IMG}"            # imgNameで指定したスプライト画像の保存先
#   # a.img.pipe gulp.dest "#{DEST_IMG}"           # imgNameで指定したスプライトcssの保存先 imageminしてDESTに展開する。
#   a.css.pipe gulp.dest "#{SRC_CSS}"            # imgNameで指定したスプライトcssの保存先

# gulp.task "cmq", ->
#   gulp.src "#{DEST_CSS}*.css"
#   .pipe cmq({
#       log: true
#     })
#     .pipe gulp.dest "#{DEST_CSS}"
#
# gulp.task "hologram", ->
#   gulp.src "config/hologram/hologram_config.yml"
#     .pipe hologram()
#
# # Generate styleguide with templates
# gulp.task "kss", ->
#     gulp.src paths.css
#     .pipe kss({
#         # overview: __dirname + '/styles/styleguide.md'
#         overview: "config/kss/styleguide.md",
#         template: 'config/kss/template/'
#     })
#     # .pipe gulp.dest 'styleguide/'
#     .pipe gulp.dest "#{DEST}styleguide/"


# css/imageフォルダ作成
gulp.task "mkdir", ->
    mkdirp "#{SRC_IMG}", dirMk
    mkdirp "#{SRC_CSS}", dirMk
    mkdirp "#{DEST_IMG}", dirMk
    mkdirp "#{DEST_CSS}", dirMk

gulp.task 'watch', ->
    # isWindows
    # gulp.watch [paths.js[0], "#{SRC}**/_*/*"], ["browserify"] # "#{SRC_JS}**/*.coffee" and ("_mixin/", "_theme/"...)
    # gulp.watch paths.cssw  , ["stylus", "hologram"]
    # gulp.watch paths.cssw  , ["stylus", "kss"]
    # gulp.watch paths.html  , ["jade"]
    # gulp.watch paths.sprite, ["sprite"]
    gulp.watch paths.img   , ["imagemin"]

gulp.task "default",["watch"]
gulp.task "build", ["imagemin", "stylus", "browserify", "jade"]
gulp.task 'concat', ['cmq']
