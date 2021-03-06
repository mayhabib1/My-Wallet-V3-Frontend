angular
  .module('walletApp')
  .controller("SignupCtrl", SignupCtrl);

SignupCtrl.$inject = ['$scope', '$state', '$cookies', '$filter', '$translate', '$uibModal', 'Wallet', 'Alerts', 'currency', 'languages'];

function SignupCtrl($scope, $state, $cookies, $filter, $translate, $uibModal, Wallet, Alerts, currency, languages) {
  $scope.working = false;
  $scope.alerts = Alerts.alerts;
  $scope.status = Wallet.status;

  $scope.$watch("status.isLoggedIn", newValue => {
    if (newValue) {
      $scope.busy = false;
      $state.go("signup.finish.show");
    }
  });

  let language_code = $translate.use();
  if(language_code == "zh_CN") {
    language_code = "zh-cn";
  }
  let language_guess = $filter("getByProperty")("code", language_code, languages);
  if (language_guess == null) {
    $scope.language_guess = $filter("getByProperty")("code", "en", languages);
  }
  $scope.currency_guess = $filter("getByProperty")("code", "USD", currency.currencies);

  $scope.fields = {
    email: "",
    password: "",
    confirmation: "",
    acceptedAgreement: false
  };

  $scope.close = () => {
    Alerts.clear();
    $state.go("wallet.common.home");
  };

  $scope.signup = () => {
    if ($scope.signupForm.$valid) {
      $scope.working = true;
      $scope.createWallet((uid) => {
        $scope.working = false;
        if (uid != null) {
          $cookies.put("uid", uid);
        }
        if ($scope.autoReload) {
          $cookies.put("password", $scope.fields.password);
        }
        $scope.close("");
      });
    }
  };

  $scope.createWallet = successCallback => {
    Wallet.create($scope.fields.password, $scope.fields.email, $scope.fields.language, $scope.fields.currency, (uid) => {
      successCallback(uid);
    });
  };

  $scope.$watch("language_guess", (newVal, oldVal) => {
    if (newVal) {
      $translate.use(newVal.code);
      Wallet.changeLanguage(newVal);
    }
  });

  $scope.$watch("currency_guess", (newVal, oldVal) => {
    if (newVal) Wallet.changeCurrency(newVal);
  });
}
