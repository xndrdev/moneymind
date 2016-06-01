Meteor.publish 'transactions', (moneyAccountId) ->
  if @userId
    if MoneyAccounts.find(_id: moneyAccountId, collaboratorIds: @userId).count()

      filter =
        'moneyAccountId': moneyAccountId
      ###
      if date
        dateParts = expense.date.split('.')

        q =
          'date': new Date(dateParts[2], dateParts[1] - 1, dateParts[0])
        _.extend(filter, q)

      if moneyAccountId
        q =
          'moneyAccountId': moneyAccountId
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
      ###
      Transactions.find filter
      ,
        sort:
          date: -1
    else
      return undefined
  else
    return undefined

Meteor.publish 'transaction', (transactionId) ->
  Transactions.find _id: transactionId

Meteor.publish 'moneyAccounts', ->
  if @userId
    MoneyAccounts.find collaboratorIds: @userId
    ,
      sort:
        createdAt: -1
  else
    []

Meteor.publish 'moneyAccount', (moneyAccountId) ->
  MoneyAccounts.find _id: moneyAccountId
