Router.configure
  layoutTemplate: 'layout'

DashboardController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'transactions'
  template: 'dashboard'
  data: ->
    transactions: Transactions.find {}
    ,
      sort:
        date: -1

TransactionsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'transactions'
  template: 'transactions'
  data: ->
    transactions: Transactions.find {}
    ,
      sort:
        date: -1

AccountsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'accounts'
  template: 'accounts'
  data: ->
    accounts: Accounts.find {}
    ,
      sort:
        createdAt: -1

UpdateAccountController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'account', @params.account_id
  template: 'updateAccount'
  data: ->
    account: Accounts.findOne _id: @params.account_id
    ,
      sort:
        createdAt: -1

AddTransactionController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'accounts'
  data: ->
    accounts: Accounts.find {}
    ,
      sort:
        createdAt: -1

UpdateTransactionController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'transaction', @params.transaction_id
    Meteor.subscribe 'accounts'
  template: 'updateTransaction'
  data: ->
    transaction: Transactions.findOne _id: @params.transaction_id
    accounts: Accounts.find {}
    ,
      sort:
        createdAt: -1

ImportTransactionsController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'accounts'
  template: 'importTransactions'
  data: ->
    accounts: Accounts.find {}
    ,
      sort:
        createdAt: -1

Router.map ->
  @route 'dashboard',
    path: '/'
    controller: DashboardController
    onAfterAction: ->
      setTitle 'Dashboard'
  @route 'accounts',
    path: '/accounts'
    controller: AccountsController
    onAfterAction: ->
      setTitle 'Konten'
  @route 'addAccount',
    path: '/accounts/add'
    onAfterAction: ->
      setTitle 'Konto hinzufügen'
  @route 'updateAccount',
    path: '/accounts/update/:account_id'
    controller: UpdateAccountController
    onAfterAction: ->
      setTitle 'Konto bearbeiten'
  @route 'transactions',
    path: '/transactions'
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
