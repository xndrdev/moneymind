@MoneyAccounts = new Mongo.Collection 'money_accounts'

Meteor.methods
  addMoneyAccount: (moneyAccount) ->
    MoneyAccounts.insert
      name: moneyAccount.name
      type: moneyAccount.type
      description: moneyAccount.description
      collaboratorIds: [Meteor.userId()]

  updateMoneyAccount: (moneyAccount) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(422, i18n 'nameIsBlank') unless company.name
    throw new Meteor.Error() unless moneyAccount._id
    #throw new Meteor.Error() unless Companies.findOne(_id: company._id, collaboratorIds: Meteor.userId())

    MoneyAccounts.update
      _id: moneyAccount._id
    ,
      $set:
        name: moneyAccount.name
        type: moneyAccount.type
        description: moneyAccount.description

  removeMoneyAccount: (moneyAccount) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(403, i18n 'missingPermission') unless Permissions.offers.isAuthor(offer._id)
    throw new Meteor.Error() unless moneyAccount._id

    MoneyAccounts.remove moneyAccount._id

    #remove all transactions with the account
    Transactions.remove moneyAccountId: moneyAccount._id

MoneyAccounts.before.insert (userId, doc) ->
  doc.createdAt = new Date()
  doc.updatedAt = new Date()
