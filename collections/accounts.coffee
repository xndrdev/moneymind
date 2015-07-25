@Accounts = new Mongo.Collection 'accounts'

Meteor.methods
  addAccount: (account) ->
    Accounts.insert
      name: account.name
      type: account.type
      description: account.description

  updateAccount: (account) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(422, i18n 'nameIsBlank') unless company.name
    throw new Meteor.Error() unless account._id
    #throw new Meteor.Error() unless Companies.findOne(_id: company._id, collaboratorIds: Meteor.userId())

    Accounts.update
      _id: account._id
    ,
      $set:
        name: account.name
        type: account.type
        description: account.description

  removeAccount: (account) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(403, i18n 'missingPermission') unless Permissions.offers.isAuthor(offer._id)
    throw new Meteor.Error() unless account._id

    Accounts.remove account._id

    #remove all transactions with the account
    Transactions.remove accountId: account._id

Accounts.before.insert (userId, doc) ->
  doc.createdAt = new Date()
  doc.updatedAt = new Date()
