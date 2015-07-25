@Transactions = new Mongo.Collection 'transactions'

Transactions.helpers account: ->
  Accounts.findOne @accountId

Meteor.methods
  addTransaction: (transaction) ->
    dateParts = transaction.date.split('.')
    value = accounting.unformat '€ ' + transaction.value, ','

    Transactions.insert
      type: transaction.type
      date: new Date(dateParts[2], dateParts[1] - 1, dateParts[0])
      value: value
      category: transaction.category
      description: transaction.description
      accountId: transaction.accountId

  updateTransaction: (transaction) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(422, i18n 'nameIsBlank') unless company.name
    throw new Meteor.Error() unless transaction._id
    #throw new Meteor.Error() unless Companies.findOne(_id: company._id, collaboratorIds: Meteor.userId())

    dateParts = transaction.date.split('.')

    Transactions.update
      _id: transaction._id
    ,
      $set:
        type: transaction.type
        date: new Date(dateParts[2], dateParts[1] - 1, dateParts[0])
        value: transaction.value
        category: transaction.category
        description: transaction.description
        accountId: transaction.accountId

  removeTransaction: (transaction) ->
    #throw new Meteor.Error(401, i18n 'notSignedIn') unless Meteor.user()
    #throw new Meteor.Error(403, i18n 'missingPermission') unless Permissions.offers.isAuthor(offer._id)
    throw new Meteor.Error() unless transaction._id

    Transactions.remove transaction._id

  importTransactions: (data) ->
    data.results.data.forEach (element, index, array) ->

      if typeof element.Valutadatum != 'undefined'
        #convert from string to number
        value = accounting.unformat '€ ' + element.Betrag, ','

        #Check if is expense
        if value <= 0
          type = 'expense'
        else
          type = 'earning'

        dateParts = element.Valutadatum.split('.')

        Transactions.insert
          type: type
          date: new Date('20'+dateParts[2], dateParts[1] - 1, dateParts[0])
          value: value
          category: 'import'
          description: element.Verwendungszweck
          accountId: data.accountId

  updateTransactionCategory: (transaction) ->
    throw new Meteor.Error() unless transaction._id

    Transactions.update
      _id: transaction._id
    ,
      $set:
        category: transaction.category

Transactions.before.insert (userId, doc) ->
  doc.createdAt = new Date()
  doc.updatedAt = new Date()
