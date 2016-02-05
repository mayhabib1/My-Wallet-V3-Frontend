angular
  .module('walletApp')
  .factory('Alerts', Alerts);

Alerts.$inject = ['$timeout', '$rootScope', '$translate', '$uibModal'];

function Alerts($timeout, $rootScope, $translate, $uibModal) {
  const service = {
    alerts          : [],
    close           : close,
    clear           : clear,
    confirm         : confirm,
    displayInfo     : display.bind(null, 'info'),
    displaySuccess  : display.bind(null, 'success'),
    displayWarning  : display.bind(null, ''),
    displayError    : display.bind(null, 'danger'),
    displayReceivedBitcoin : display.bind(null, 'received-bitcoin'),
    displaySentBitcoin: display.bind(null, 'sent-bitcoin'),
    displayVerifiedEmail : displayVerifiedEmail,
    displayResetTwoFactor : displayResetTwoFactor
  };

  function close(alert, context=service.alerts) {
    $timeout.cancel(alert.timer);
    context.splice(context.indexOf(alert), 1);
  }

  function clear(context=service.alerts) {
    while (context.length > 0) {
      let alert = context.pop();
      $timeout.cancel(alert.timer);
    }
  }

  function display(type, message, keep=false, context=service.alerts) {
    let alert = { type: type, msg: message };
    alert.close = close.bind(null, alert, context);
    if (!keep) alert.timer = $timeout(() => alert.close(), 7000);
    context.push(alert);
  }

  function confirm(message) {
    return $uibModal.open({
      windowClass: 'bc-modal',
      templateUrl: 'partials/confirm.jade',
      controller: function ($scope, $uibModalInstance) {
        $scope.message = message;
        $scope.confirm = () => $uibModalInstance.close(true);
        $scope.close = () => $uibModalInstance.close(false);
      }
    }).result;
  }

  function displayVerifiedEmail() {
    $translate(['SUCCESS', 'EMAIL_VERIFIED_SUCCESS']).then(translations => {
      $rootScope.$emit('showNotification', {
        type: 'verified-email',
        icon: 'ti-email',
        heading: translations.SUCCESS,
        msg: translations.EMAIL_VERIFIED_SUCCESS
      });
    });
  }

  function displayResetTwoFactor(message) {
    $translate(['SUCCESS']).then(translations => {
      $rootScope.$emit('showNotification', {
        type: 'verified-email',
        icon: 'ti-email',
        heading: translations.SUCCESS,
        msg: message
      });
    });
  }

  return service;
}
