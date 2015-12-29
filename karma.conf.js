module.exports = function(karma){
  var configuration = {

    basePath : './',

    // logLevel: config.LOG_DISABLE,

    exclude: ['assets/js/my_wallet/'],

    files : [
      'bower_components/angular/angular.js',
      'bower_components/angular-sanitize/angular-sanitize.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'bower_components/angular-animate/angular-animate.js',
      'bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
      'bower_components/angular-cookies/angular-cookies.js',
      'bower_components/angular-ui-select/dist/select.js',
      'bower_components/angular-audio/app/angular.audio.js',
      'bower_components/qrcode/lib/qrcode.min.js',
      'bower_components/angular-qr/angular-qr.min.js',
      'bower_components/angular-inview/angular-inview.js',
      'build/js/browser-polyfill.js',
      'assets/js/app.js',
      'assets/js/core/core.module.js',
      'build/js/templates.js',
      'assets/js/controllers/**/*.controller.js',
      'assets/js/filters.js',
      'assets/js/services/**/*.service.js',
      'assets/js/directives/*.js.coffee',
      'assets/js/directives/*.js',
      'assets/js/core/*.js',
      'tests/mocks/**/*.coffee',
      'tests/*.coffee',
      'tests/controllers/**/*.coffee',
      'tests/directives/*.coffee',
      'tests/filters/*.coffee',
      'tests/services/**/*.coffee',
      'tests/**/*.js',
      'app/templates/*.jade',
      'bower_components/angular-password-entropy/password-entropy.js',
    ],

    autoWatch : true,

    preprocessors: {
      '**/*.jade': ['ng-jade2js'],
      'assets/js/core/core.module.js': ['babel'],
      'assets/js/controllers/**/*.js' : ['coverage'],
      'assets/js/filters.js' : ['coverage'],
      'assets/js/services/*.js.coffee' : ['coffee','coverage'],
      'assets/js/services/*.service.js' : ['coverage'],
      'assets/js/directives/*.js.coffee' : ['coffee','coverage'],
      'assets/js/directives/*.js' : ['coverage'],
      'assets/js/core/*.service.js': ['babel'],
      'assets/js/my_wallet.js.coffee': ['coffee'],
      'assets/js/routes.js' : ['coverage'],
      'assets/js/app.js' : ['coverage'],
      'tests/**/*.coffee' : ['coffee'],
      'tests/**/*.js' : ['babel']
    },
    coffeePreprocessor: {
      // options passed to the coffee compiler
      options: {
        bare: true,
        sourceMap: true
      },
      // transforming the filenames
      transformPath: function(path) {
        return path.replace(/\.coffee$/, '.js');
      }
    },
    babelPreprocessor: {
      options: {
        sourceMap: 'inline'
      },
      filename: function (file) {
        return file.originalPath.replace(/\.js$/, '.es5.js');
      },
      sourceFileName: function (file) {
        return file.originalPath;
      }
    },

    ngJade2JsPreprocessor: {
      stripPrefix: 'app/',
      prependPrefix: '',

      // or define a custom transform function
      // cacheIdFromPath: function(filepath) {
      //   console.log(filepath);
      //   return null;
      // },

      // Support for jade locals to render at compile time
      // locals: {
      //   foo: 'bar'
      // },

      templateExtension: 'html',

      // setting this option will create only a single module that contains templates
      // from all the files, so you can load them all with module('foo')
      // moduleName: 'foo',

      // Jade compiler options. For a list of possible options, consult Jade documentation.
      jadeOptions: {
        doctype: 'xml'
      }
    },

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    reporters: ['progress','osx', 'coverage'],

    coverageReporter: {
      reporters: [
        { type : 'html', dir : 'coverage/'},
        { type : 'lcov', dir : 'coverage-lcov/'}
      ],

      subdir: '.',

      instrumenters: { isparta : require('isparta') },

      instrumenter: {
          '**/*.js': 'isparta'
      }
    }



  }

  if(process.env.TRAVIS) {
  }

  karma.set(configuration);
};
