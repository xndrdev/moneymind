Meteor.publish 'transactions', (date, accountId, value, category, description) ->
  filter = {}

  if date
    dateParts = expense.date.split('.')

    q =
      'date': new Date(dateParts[2], dateParts[1] - 1, dateParts[0])
    _.extend(filter, q)

  if accountId
    q =
      'accountId': accountId
    _.extend(filter, q)

  if value
    q =
      'value': accounting.unformat '€ ' + value, ','
    _.extend(filter, q)

  if category
    q =
      'category': new RegExp(category, 'i')
    _.extend(filter, q)

  if description
    q =
      'description': new RegExp(description, 'i')
    _.extend(filter, q)

  Transactions.find filter
  ,
    sort:
      date: -1

Meteor.publish 'transaction', (transactionId) ->
  Transactions.find _id: transactionId

Meteor.publish 'accounts', ->
  Accounts.find {}
  ,
    sort:
      createdAt: -1

Meteor.publish 'account', (accountId) ->
  Accounts.find _id: accountId
