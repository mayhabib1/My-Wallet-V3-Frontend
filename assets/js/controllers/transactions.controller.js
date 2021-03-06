angular
  .module('walletApp')
  .controller("TransactionsCtrl", TransactionsCtrl);

function TransactionsCtrl($scope, Wallet, MyWallet, $timeout, $stateParams, $state) {
  $scope.addressBook  = Wallet.addressBook;
  $scope.status       = Wallet.status;
  $scope.settings     = Wallet.settings;
  $scope.totals       = Wallet.totals;
  $scope.accounts     = Wallet.accounts;

  $scope.getTotal     = Wallet.total;

  $scope.loading      = false;
  $scope.allTxsLoaded = false;
  $scope.canDisplayDescriptions = false;

  let accountIndex    = $stateParams.accountIndex;
  let txList          = MyWallet.wallet.txList;
  $scope.transactions = txList.transactions(accountIndex);

  let fetchTxs = () => {
    $scope.loading = true;
    txList.fetchTxs().then((numFetched) => {
      $timeout(() => {
        $scope.allTxsLoaded = numFetched < txList.loadNumber;
        $scope.loading = false;
      });
    }).catch(() => {
      $timeout(() => $scope.loading = false);
    });
  };

  if ($scope.transactions.length === 0) fetchTxs();

  $scope.nextPage = () => {
    if (!$scope.allTxsLoaded && !$scope.loading) fetchTxs();
  };

  $scope.showTransaction = (transaction) => {
    $state.go("wallet.common.transaction", {
      accountIndex: $stateParams.accountIndex,
      hash: transaction.hash
    });
  };

  $scope.$watchCollection("accounts()", newValue => {
    $scope.canDisplayDescriptions = $scope.accounts().length > 0;
  });

  let setTxs = () =>
    $scope.transactions = txList.transactions(accountIndex);

  let unsub = txList.subscribe(setTxs);
  $scope.$on('$destroy', unsub);

  // Searching and filtering
  $scope.filterTypes = ['ALL', 'SENT', 'RECEIVED_BITCOIN_FROM', 'MOVED_BITCOIN_TO'];
  $scope.setFilterType = type => {
    $scope.filterBy = $scope.filterTypes[type];
  };
  $scope.isFilterType = (type) => $scope.filterBy === $scope.filterTypes[type];
  $scope.setFilterType(0);

  $scope.transactionFilter = item => {
    return ($scope.filterByType(item) &&
            $scope.filterSearch(item, $scope.searchText));
  };

  $scope.filterSearch = (tx, search) => {
    if (search === '' || (search == null)) return true;
    return ($scope.filterTx(tx.processedInputs, search) ||
            $scope.filterTx(tx.processedOutputs, search));
  };

  $scope.filterTx = (coins, search) => {
    return coins
      .map(coin => coin.label || coin.address)
      .join(', ').toLowerCase().search(search.toLowerCase()) > -1;
  };

  $scope.filterByType = tx => {
    switch ($scope.filterBy) {
      case $scope.filterTypes[0]:
        return true;
      case $scope.filterTypes[1]:
        return tx.txType === 'sent';
      case $scope.filterTypes[2]:
        return tx.txType === 'received';
      case $scope.filterTypes[3]:
        return tx.txType === 'transfer';
    }
    return false;
  };

}
