Template.addTransaction.events
  'submit [data-id=add-transaction-form]': (event, template) ->
    event.preventDefault()

    transaction =
      type: template.find('[data-id=type]').value
      date: template.find('[data-id=date]').value
      value: accounting.unformat '€ ' + template.find('[data-id=value]').value, ','
      category: template.find('[data-id=category]').value
      description: template.find('[data-id=description]').value
      accountId: template.find('[data-id=account-id]').value

    Meteor.call 'addTransaction', transaction, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'transactions'
