describe "AddressImportCtrl", ->
  scope = undefined
  Wallet = undefined
  Alerts = undefined

  accounts = [{index: 0, label: "Spending", archived: false}]

  modalInstance =
    close: ->
    dismiss: ->

  beforeEach angular.mock.module("walletApp")

  beforeEach ->
    angular.mock.inject ($injector, $rootScope, $controller, $compile) ->
      Wallet = $injector.get("Wallet")
      Alerts = $injector.get("Alerts")

      Wallet.addAddressOrPrivateKey = (addressOrPrivateKey, bip38passphrase, success, error) ->
        success({address: "valid_import_address"})

      Wallet.accounts = () -> accounts

      Wallet.my =
        wallet:
          keys: []
        isValidAddress: (addr) -> addr == 'watch_only'
        isValidPrivateKey: (priv) -> priv == 'valid_import_address'

      Alerts.confirm = () ->
        then: (f) -> f(true)

      scope = $rootScope.$new()

      $controller "AddressImportCtrl",
        $scope: scope,
        $stateParams: {},
        $uibModalInstance: modalInstance
        address: null

      element = angular.element(
        '<form role="form" name="importForm" novalidate>' +
        '<input type="textarea" name="privateKey"       ng-model="fields.addressOrPrivateKey"   is-valid="isValidAddressOrPrivateKey(fields.addressOrPrivateKey)"     ng-disabled="BIP38"    ng-change="importForm.privateKey.$setValidity(\'present\', true)"   required />' +
        '<input type="password" name="bipPassphrase"    ng-model="fields.bip38passphrase"       ng-change="importForm.bipPassphrase.$setValidity(\'wrong\', true)"      ng-required="BIP38" />' +
        '</form>'
      )
      scope.model = { fields: {} }
      $compile(element)(scope)

      scope.$digest()

      return

    return

  it "should exist", ->
    expect(scope.close).toBeDefined()

  it "should have access to wallet accounts", inject((Wallet) ->
    expect(scope.accounts()).toEqual(Wallet.accounts())
  )

  describe "enter address or private key", ->

    it "should go to step 2 when user clicks validate", inject(($timeout) ->
      scope.fields.addressOrPrivateKey = "valid_import_address"
      expect(scope.step).toBe(1)
      scope.import()
      $timeout.flush()
      expect(scope.step).toBe(2)
    )

  describe "watch only", ->

    beforeEach ->
      scope.fields.addressOrPrivateKey = "watch_only"

    it "should not go to step 2 when the user does not confirm", inject(($timeout) ->
      spyOn(Alerts, 'confirm').and.returnValue(then: (f) -> f(false))
      expect(scope.step).toBe(1)
      scope.import()
      $timeout.flush()
      expect(scope.step).toBe(1)
      expect(scope.status.busy).toEqual(false)
    )

  describe "validate and add", ->
    it "should add the address if no errors are present", inject(($timeout) ->
      scope.fields.addressOrPrivateKey = "valid_import_address"
      scope.import()
      $timeout.flush()
      expect(scope.address.address).toBe("valid_import_address")
    )

    it "should show the balance", inject(($timeout) ->
      scope.fields.addressOrPrivateKey = "valid_import_address"
      scope.import()
      $timeout.flush()
      expect(scope.address.balance).not.toBe(0)
    )

    it "should go to step 3 when user clicks transfer", ->
      scope.goToTransfer()
      expect(scope.step).toBe(3)

  describe "transfer", ->
    beforeEach ->
      scope.address = Wallet.legacyAddresses()[0]

    it "should have access to accounts", ->
      expect(scope.accounts()).toBeDefined()

    it "should show a spinner during sweep",  inject((Wallet) ->
      pending()
      spyOn(Wallet, "transaction").and.callFake((success, error) ->
        expect(scope.status.sweeping).toBe(true)
        {
          sweep: () ->
            success()
        }
      )

      expect(scope.status.sweeping).toBe(false)

      scope.transfer()

      # This is called after success:
      expect(scope.status.sweeping).toBe(false)

    )

  describe "parseBitcoinUrl()", ->
    it "should work with prefix", ->
      expect(scope.parseBitcoinUrl("1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")).toBe("1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")

    it "should work without slashes", ->
      expect(scope.parseBitcoinUrl("bitcoin:1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")).toBe("1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")

    it "should work with slashes", ->
      expect(scope.parseBitcoinUrl("bitcoin://1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")).toBe("1GjW7vwRUcz5YAtF625TGg2PsCAM8fRPEd")
