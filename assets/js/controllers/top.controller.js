angular
  .module('walletApp')
  .controller("TopCtrl", TopCtrl);

function TopCtrl($scope, $stateParams, Wallet, currency) {
  $scope.settings = Wallet.settings;
  $scope.isBitCurrency = currency.isBitCurrency;
  $scope.toggleDisplayCurrency = Wallet.toggleDisplayCurrency;
  $scope.status = Wallet.status;
  $scope.accountIndex = $stateParams.accountIndex;

  $scope.getTotal = (index) => Wallet.total(index);
}
