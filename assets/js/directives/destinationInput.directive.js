angular
  .module('walletApp')
  .directive('destinationInput', destinationInput);

destinationInput.$inject = ['$rootScope', '$timeout', 'Wallet', 'format'];

function destinationInput($rootScope, $timeout, Wallet, format) {
  const directive = {
    restrict: 'E',
    require: 'ngModel',
    scope: {
      model: '=ngModel',
      onRequestQr: '&',
      change: '&ngChange'
    },
    templateUrl: 'templates/destination-input.jade',
    link: link
  };
  return directive;

  function link(scope, elem, attrs, ctrl) {
    scope.browserWithCamera = $rootScope.browserWithCamera;
    scope.destinations = Wallet.accounts()
                                .concat(Wallet.legacyAddresses())
                                .filter(a => !a.archived)
                                .map(format.destination);

    scope.setModel = (a) => {
      scope.model = a;
      $timeout(scope.change);
    };

    scope.clearModel = () => {
      scope.model = { type: 'External' };
      scope.model.address = '';
      $timeout(scope.change);
    };

    scope.focusInput = (t) => {
      $timeout(() => elem.find('input')[0].focus(), t || 50);
    };

    let blurTime;
    scope.blur = () => {
      blurTime = $timeout(() => {
        ctrl.$setTouched();
      }, 250);
    };

    scope.focus = () => {
      $timeout.cancel(blurTime);
      ctrl.$setUntouched();
    };

    if (!scope.model) scope.clearModel();
    scope.focusInput(250);
    scope.$watch('model', scope.change);
  }
}
