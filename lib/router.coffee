Router.configure
  layoutTemplate: 'layout'

TransactionsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'transactions'
  template: 'transactions'
  data: ->
    transactions: Transactions.find {}
    ,
      sort:
        date: -1

MoneyAccountsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'moneyAccounts'
  template: 'moneyAccounts'
  data: ->
    moneyAccounts: MoneyAccounts.find {}
    ,
      sort:
        createdAt: -1

UpdateMoneyAccountController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'moneyAccount', @params.money_ccount_id
  template: 'updateMoneyAccount'
  data: ->
    moneyAccount: MoneyAccounts.findOne _id: @params.money_account_id
    ,
      sort:
        createdAt: -1

AddTransactionController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'moneyAccounts'
  data: ->
    moneyAccounts: MoneyAccounts.find {}
    ,
      sort:
        createdAt: -1

UpdateTransactionController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'transaction', @params.transaction_id
    Meteor.subscribe 'moneyAccounts'
  template: 'updateTransaction'
  data: ->
    transaction: Transactions.findOne _id: @params.transaction_id
    moneyAccounts: MoneyAccounts.find {}
    ,
      sort:
        createdAt: -1

ImportTransactionsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'moneyAccounts'
  template: 'importTransactions'
  data: ->
    moneyAccounts: MoneyAccounts.find {}
    ,
      sort:
        createdAt: -1

Router.map ->
  @route 'moneyAccounts',
    path: '/money_accounts'
    controller: MoneyAccountsController
    onAfterAction: ->
      setTitle 'Konten'
  @route 'addMoneyAccount',
    path: '/money_accounts/add'
    onAfterAction: ->
      setTitle 'Konto hinzufügen'
  @route 'updateMoneyAccount',
    path: '/money_accounts/update/:money_account_id'
    controller: UpdateMoneyAccountController
    onAfterAction: ->
      setTitle 'Konto bearbeiten'
  @route 'transactions',
    path: '/'
    onAfterAction: ->
      setTitle 'Transaktionen'
  @route 'addTransaction',
    path: '/transactions/add'
    controller: AddTransactionController
    onAfterAction: ->
      setTitle 'Transaktion hinzufügen'
  @route 'updateTransaction',
    path: '/transactions/update/:transaction_id'
    controller: UpdateTransactionController
    onAfterAction: ->
      setTitle 'Transaction bearbeiten'
  @route 'importTransactions',
    path: '/transactions/import'
    controller: ImportTransactionsController
    onAfterAction: ->
      setTitle 'Transatkionen importieren'
  @route 'signIn',
    path: '/sign_in'
    onAfterAction: ->
      setTitle 'Anmelden'
  @route 'signUp',
    path: '/sign_up'
    onAfterAction: ->
      setTitle 'Registrieren'
  @route 'signOut',
    template: 'signIn'
    path: '/sign_out'
    onBeforeAction: ->
      Meteor.logout ->
        Router.go 'signIn'
      @next()

isSignedIn = ->
  return unless @ready()
  unless Meteor.loggingIn() or Meteor.user()
    @redirect 'signIn'
  @next()

forbiddenRoutesWhenSignedIn = ->
  return unless @ready()
  if Meteor.loggingIn() or Meteor.user()
    @redirect '/'
  @next()

Router.onBeforeAction forbiddenRoutesWhenSignedIn,
  only: [
    'signUp'
    'signIn'
  ]

Router.onBeforeAction isSignedIn,
  except: [
    # permitted routes for the not-signed-in-User
    'signUp'
  ]
