fs = require("fs")
path = require("path")
require 'shelljs/global'

module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    clean: {
      build: ["build"]
      dist: ["dist", "bower_components", "node_modules"]
      test: ["coverage"]
      sass: [".sass-cache"]
    }
    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"
        mangle: false

      application_dependencies:
        src: "build/application-dependencies.js"
        dest: "build/application-dependencies.min.js"
        options: {
          mangle: false
        }

    preprocess:
      html:
        options: {
          context : {
            PRODUCTION: true
          }
        },
        expand: true
        src: ['build/index.html']
        dest: ''

    concat:
      options:
        banner: "(function(){"
        separator: ";"
        footer: "})();"

      application_dependencies:
        src: [
          'build/js/browser-polyfill.js' # Babel polyfill
          'build/js/core/core.module.js'
          'build/js/app.js' # Needs to be included before controllers
          'build/js/core/*.service.js'
          'build/js/services/*.js'
          'build/js/controllers/*.js'
          'build/js/controllers/settings/*.js'
          'build/js/directives/*.js'
          'build/js/filters.js'
          'build/js/routes.js'
          'build/js/translations.js'
          'build/bower_components/angular-audio/app/angular.audio.js'
          'build/bower_components/angular-inview/angular-inview.js'
          'build/js/templates.js'
          'build/bower_components/webcam-directive/app/scripts/webcam.js'
          'build/bower_components/bc-qr-reader/dist/bc-qr-reader.js'
          'build/bower_components/angular-password-entropy/password-entropy.js'
          'build/bower_components/qrcode/lib/qrcode.js'
          'build/bower_components/angular-qr/src/angular-qr.js'
          'build/bower_components/angular-ui-select/dist/select.js'
          'build/bower_components/angular-ui-router/release/angular-ui-router.js'
          'build/bower_components/angular-translate/angular-translate.js'
          'build/bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.js'
          'build/bower_components/digits-trie/dist/digits-trie.js'
          'build/bower_components/google-libphonenumber/dist/browser/libphonenumber.js'
          'build/bower_components/bc-countries/dist/bc-countries.js'
          'build/bower_components/bc-phone-number/dist/js/bc-phone-number.js'
          'build/bower_components/browserdetection/src/browser-detection.js'
        ]

        dest: "build/application-dependencies.js"

      application: # All components should first be minimized. Only trusted sources should be imported as minified..
        src: [
          'build/bower_components/blockchain-wallet/dist/my-wallet.min.js'
          'build/bower_components/angular/angular.min.js'
          'build/bower_components/angular-sanitize/angular-sanitize.min.js'
          'build/bower_components/angular-cookies/angular-cookies.min.js'
          'build/bower_components/angular-animate/angular-animate.min.js'
          'build/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js'
          'build/application-dependencies.min.js'
        ]

        dest: "dist/js/application.min.js"

    coffee:
      coffee_to_js:
        options:
          bare: true
          sourceMap: false
        expand: true
        flatten: false
        cwd: "assets/js"
        src: ["*.js.coffee", "directives/**/*.js.coffee", "services/**/*.js.coffee"]
        dest: 'build/js'
        ext: ".js"

    sass:
      build:
        files: [{
          expand: true,
          cwd: 'assets/css',
          src: ['**/*.scss'],
          dest: 'build/css',
          ext: '.css'
        }]
      options:
        loadPath: ["bower_components/bootstrap-sass/assets/stylesheets"]

    concat_css: {
      app: {
        src: [
          "build/bower_components/angular-ui-select/dist/select.min.css"
          "build/bower_components/bc-css-flags/dist/css/bc-css-flags.css"
          "build/bower_components/bc-phone-number/dist/css/bc-phone-number.css"
          "build/css/blockchain.css" # Needs to be loaded first
          "build/css/**/*.css"
        ],
        dest: "dist/css/application.css"
      }
    },

    autoprefixer: {
      options: {
        browsers: ['last 2 versions']
      }
      no_dest_multiple: {
        src: 'build/css/*.css'
      }
    },

    html2js: {
      options:
        jade:
          doctype: "html"
        base: "app"
        singleModule: true
      main: {
        src: ["app/partials/notifications/*.jade", "app/partials/settings/*.jade", "app/partials/*.jade", "app/templates/*.jade"],
        dest: 'build/js/templates.js'
      }
    },
    "merge-json": # TODO: generate this list...
      bg: {src: [ "locales/bg-*.json" ], dest: "build/locales/bg.json"}
      da: {src: [ "locales/da-*.json" ], dest: "build/locales/da.json"}
      de: {src: [ "locales/de-*.json" ], dest: "build/locales/de.json"}
      el: {src: [ "locales/el-*.json" ], dest: "build/locales/el.json"}
      en: {src: [ "locales/en-*.json" ], dest: "build/locales/en.json"}
      es: {src: [ "locales/es-*.json" ], dest: "build/locales/es.json"}
      fr: {src: [ "locales/fr-*.json" ], dest: "build/locales/fr.json"}
      hi: {src: [ "locales/hi-*.json" ], dest: "build/locales/hi.json"}
      hu: {src: [ "locales/hu-*.json" ], dest: "build/locales/hu.json"}
      id: {src: [ "locales/id-*.json" ], dest: "build/locales/id.json"}
      it: {src: [ "locales/it-*.json" ], dest: "build/locales/it.json"}
      ja: {src: [ "locales/ja-*.json" ], dest: "build/locales/ja.json"}
      ko: {src: [ "locales/ko-*.json" ], dest: "build/locales/ko.json"}
      nl: {src: [ "locales/nl-*.json" ], dest: "build/locales/nl.json"}
      no: {src: [ "locales/no-*.json" ], dest: "build/locales/no.json"}
      pl: {src: [ "locales/pl-*.json" ], dest: "build/locales/pl.json"}
      pt: {src: [ "locales/pt-*.json" ], dest: "build/locales/pt.json"}
      ro: {src: [ "locales/ro-*.json" ], dest: "build/locales/ro.json"}
      ru: {src: [ "locales/ru-*.json" ], dest: "build/locales/ru.json"}
      sl: {src: [ "locales/sl-*.json" ], dest: "build/locales/sl.json"}
      sv: {src: [ "locales/sv-*.json" ], dest: "build/locales/sv.json"}
      th: {src: [ "locales/th-*.json" ], dest: "build/locales/th.json"}
      tr: {src: [ "locales/tr-*.json" ], dest: "build/locales/tr.json"}
      vi: {src: [ "locales/vi-*.json" ], dest: "build/locales/vi.json"}
      "zh-cn": {src: [ "locales/zh-cn-*.json" ], dest: "build/locales/zh-cn.json"}

    copy:
      main:
        files: [
          {src: ["beep.wav"], dest: "dist/"}
          {src: ["index.html"], dest: "dist/", cwd: "build", expand: true}
          {src: ["img/*"], dest: "dist/", cwd: "build", expand: true}
          {src: ["locales/*"], dest: "dist/", cwd: "build", expand: true}
          {src: ["**/*"], dest: "dist/fonts", cwd: "build/fonts", expand: true}
        ]

      js:
        files: [
          {src: ["browser-polyfill.js"], dest: "build/js/", cwd: "node_modules/grunt-babel/node_modules/babel-core", expand: true}
        ]


      css:
        files: [
          {src: ["font-awesome.min.css"], dest: "build/css", cwd: "bower_components/fontawesome/css", expand: true }
          {src: ["*.css"], dest: "build/css", cwd: "assets/css", expand: true }
        ]
      fonts:
        files: [
          {src: ["bootstrap/*"], dest: "build/fonts", cwd: "bower_components/bootstrap-sass/assets/fonts", expand: true}
          {src: ["*"], dest: "build/fonts", cwd: "assets/fonts/bc-icons", expand: true}
          {src: ["*"], dest: "build/fonts", cwd: "assets/fonts/roboto", expand: true}
          {src: ["*"], dest: "build/fonts", cwd: "assets/fonts/themify", expand: true}

        ]

      images:
        files: [
          {src: ["*"], dest: "build/img", cwd: "img", expand: true }
          {src: ["*"], dest: "build/img", cwd: "bower_components/bc-css-flags/dist/img", expand: true}
        ]

    watch:
      jade:
        files: ['app/partials/**/*.jade', 'app/templates/**/*.jade']
        tasks: ['html2js']
        options:
          spawn: false

      css:
        files: ['assets/css/**/*.scss']
        tasks: ['sass', 'copy:css', 'copy:fonts']
        options:
          spawn: false

      es6:
        files: ['assets/js/controllers/**/*.js','assets/js/services/**/*.js','assets/js/directives/**/*.js','assets/js/core/**/*.js','assets/js/*.js']
        tasks: ['babel:build']
        options:
          spawn: false

      js:
        files: ['assets/js/**/*.js.coffee']
        tasks: ['compile']
        options:
          spawn: false

      locales:
        files: ['locales/*.json']
        tasks: ['merge-json']
        options:
          spawn: false

    jade:
      html:
        options:
          client: false
        files:
          "build/index.html": "app/index.jade"

    babel:
      options:
        sourceMap: true
      build:
        files: [{
          expand: true,
          cwd: 'assets/js',
          src: ['**/*.controller.js','services/**/*.js','directives/**/*.js','core/**/*.js','*.js'],
          dest: 'build/js',
        }]

    rename:
      assets: # Renames all images, fonts, etc and updates application.min.js and application.css with their new names.
        options:
          skipIfHashed: true
          startSymbol: "{{"
          endSymbol: "}}"
          algorithm: "sha1"
          format: "{{basename}}-{{hash}}.{{ext}}"

          callback: (befores, afters) ->
            publicdir = fs.realpathSync("dist")

            # Start with the longest file names, so e.g. some-font.woff2 is renamed before some-font.woff.
            tuples = new Array
            i = 0
            while i < befores.length
              tuples.push [path.relative(publicdir, befores[i]),path.relative(publicdir, afters[i])]
              i++

            tuples.sort((a,b) -> b[0].length - a[0].length)

            ordered_befores = tuples.map((t)->t[0])
            ordered_afters  = tuples.map((t)->t[1])

            for referring_file_path in ["dist/js/application.min.js", "dist/css/application.css", "dist/index.html"]
              contents = grunt.file.read(referring_file_path)
              before = undefined
              after = undefined
              i = 0

              while i < ordered_befores.length
                before = ordered_befores[i]
                after  = ordered_afters[i]
                contents = contents.split("build/" + before).join(after)
                contents = contents.split(before).join(after)

                i++
              grunt.file.write referring_file_path, contents
            return

        files:
          src: [
            'dist/img/*'
            'dist/fonts/*.*'
            'dist/fonts/bootstrap/*'
            'dist/locales/*'
            'dist/beep.wav'
          ]

      html: # Renames application.min.js/css and updates index.html
        options:
          skipIfHashed: true
          startSymbol: "{{"
          endSymbol: "}}"
          algorithm: "sha1"
          format: "{{basename}}-{{hash}}.{{ext}}"

          callback: (befores, afters) ->
            publicdir = fs.realpathSync("dist")

            for referring_file_path in ["dist/index.html"]
              contents = grunt.file.read(referring_file_path)
              before = undefined
              after = undefined
              i = 0

              while i < befores.length
                before = path.relative(publicdir, befores[i])
                after = path.relative(publicdir, afters[i])
                contents = contents.split(before).join(after)

                i++
              grunt.file.write referring_file_path, contents

        files:
          src: [
            'dist/js/application.min.js'
            'dist/css/application.css'
          ]

    shell:
      clean_bower_and_npm_cache:
        command: () ->
          'bower cache clean && npm cache clean'

      check_dependencies:
        command: () ->
          'mkdir -p build && ruby ./check-dependencies.rb'

      skip_check_dependencies:
        command: () ->
          'cp -r node_modules build && cp -r bower_components build'

      npm_install_dependencies:
        command: () ->
           'npm install'

      bower_install_dependencies:
        command: () ->
           'cp bower.json build/ && cd build && bower install'

      check_translations:
        command: () ->
          'ruby check_translations.rb'

      check_pgp_signatures:
        command: () ->
          'ruby ./check_pgp_signatures.rb'

    git_changelog:
      default:
        options:
          file: 'Changelog.md',
          app_name : 'Blockchain HD Frontend',
          # logo : 'https://raw.githubusercontent.com/blockchain/My-Wallet-HD-Frontend/changelog/assets/icons/png/logo.png',
          intro : 'Recent changes'
          grep_commits: '^fix|^feat|^docs|^style|^refactor|^chore|^test|BREAKING'
          repo_url: 'https://github.com/blockchain/My-Wallet-HD-Frontend'
          branch_name: 'master'

    coveralls:
      options:
        debug: true
        coverageDir: 'coverage-lcov'
        dryRun: false
        force: true
        recursive: true

    replace:
      root_url:
        src: ['build/js/services/wallet.service.js'],
        overwrite: true,
        replacements: [{
          from: 'customRootURL = $rootScope.rootURL'
          to: () =>
            'customRootURL = $rootScope.rootURL = "https://' + @rootUrl + '/"'
        }]
      root_path:
        src: ['build/js/services/wallet.service.js'],
        overwrite: true,
        replacements: [{
          from: 'customRootPath = $rootScope.rootPath'
          to: () =>
            'customRootPath = $rootScope.rootPath = "' + @rootPath + '/"'
        }]
      web_socket_url:
        src: ['build/js/services/wallet.service.js'],
        overwrite: true,
        replacements: [{
          from: 'customWebSocketURL = $rootScope.webSocketURL'
          to: () =>
            'customWebSocketURL = "wss://' + @rootUrl + '/inv"'
        }]
      version_frontend:
        src: ['build/js/services/wallet.service.js'],
        overwrite: true,
        replacements: [{
          from: 'versionFrontend = null'
          to: () =>
            'versionFrontend = "' + @versionFrontend + '"'
        }]

      version_my_wallet:
        src: ['build/js/services/wallet.service.js'],
        overwrite: true,
        replacements: [{
          from: 'versionMyWallet = null'
          to: () =>
            version = exec('cat build/bower_components/blockchain-wallet/.bower.json | grep \'version\": \' | grep -o \'\\d.\\d\.\\d*\'').output
            'versionMyWallet = "' + version + '"'
        }]

  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-concat-css')
  grunt.loadNpmTasks('grunt-html2js')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-rename-assets')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-preprocess')
  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-merge-json')
  grunt.loadNpmTasks('git-changelog')
  grunt.loadNpmTasks('grunt-babel')
  grunt.loadNpmTasks('grunt-karma-coveralls')
  grunt.loadNpmTasks('grunt-text-replace')

  grunt.registerTask "compile", ["coffee"]

  grunt.registerTask "build", [
    "html2js"
    "compile"
    "babel:build"
    "sass"
    "copy:js"
    "copy:css"
    "copy:fonts"
    "autoprefixer"
    "copy:images"
    "merge-json"
  ]

  grunt.registerTask "default", [
    "build"
    "watch"
  ]

  # Default task(s).
  grunt.registerTask "dist", (rootUrl, port, rootPath, versionFrontend) =>
    grunt.task.run [
      "shell:clean_bower_and_npm_cache"
      "clean"
      "shell:npm_install_dependencies"
      "build"
    ]

    @versionFrontend = versionFrontend

    if rootUrl
      @rootUrl = rootUrl

      if port
        @rootUrl += ":" + port


      console.log("Custom root URL: " + @rootUrl)

      grunt.task.run [
        "replace:root_url"
        "replace:web_socket_url"
      ]

    if rootPath
      @rootPath = rootPath

      console.log("Custom root path: " + @rootPath)

      grunt.task.run [
        "replace:root_path"
      ]

    grunt.task.run [
      "replace:version_frontend"
      "shell:check_dependencies"
      "shell:npm_install_dependencies"
      "shell:bower_install_dependencies"
      "replace:version_my_wallet"
      "shell:check_pgp_signatures"
      "concat:application_dependencies"
      "uglify:application_dependencies"
      "concat:application"
      "concat_css:app"
      "jade"
      "preprocess"
      "copy:main"
      "rename:assets"
      "rename:html"
      "git_changelog"
    ]

  grunt.registerTask "dist_unsafe", (rootUrl, port, rootPath, versionFrontend) =>
    console.warn "Do not deploy this to production."
    console.warn "Make sure your bower_components and node_modules are up to date"
    grunt.task.run [
      "build"
    ]

    @versionFrontend = versionFrontend

    if rootUrl
      @rootUrl = rootUrl

      if port
        @rootUrl += ":" + port

      console.log("Custom root URL: " + @rootUrl)

      grunt.task.run [
        "replace:root_url"
        "replace:web_socket_url"
      ]

      if rootPath
        @rootPath = rootPath

        console.log("Custom root path: " + @rootPath)

        grunt.task.run [
          "replace:root_path"
        ]

    grunt.task.run [
      "replace:version_frontend"
      "shell:skip_check_dependencies"
      "replace:version_my_wallet"
      "concat:application_dependencies"
      "uglify:application_dependencies"
      "concat:application"
      "concat_css:app"
      "jade"
      "preprocess"
      "copy:main"
      "rename:assets"
      "rename:html"
    ]

  grunt.registerTask "check_translations", [
    "shell:check_translations"
  ]

  return
