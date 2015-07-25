Template.updateTransaction.events
  'submit [data-id=update-transaction-form]': (event, template) ->
    event.preventDefault()

    transaction =
      _id: template.data.transaction._id
      type: template.find('[data-id=type]').value
      date: template.find('[data-id=date]').value
      value: accounting.unformat '€ ' + template.find('[data-id=value]').value, ','
      category: template.find('[data-id=category]').value
      description: template.find('[data-id=description]').value
      accountId: template.find('[data-id=account-id]').value

    Meteor.call 'updateTransaction', transaction, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'transactions'
        sweetAlert 'Erfolg', 'Die Transaktion wurde erfolgreich bearbeitet', 'success'

Template.updateTransaction.helpers
  isSelectedAccount: (id, accountId) ->
    return 'selected' if id is accountId

  selectedIfTransactionTypeExpense: (type) ->
    return 'selected' if type is 'expsene'

  selectedIfTransactionTypeEarning: (type) ->
    return 'selected' if type is 'earning'
