Template.addMoneyAccount.events
  'submit [data-id=add-money-account-form]': (event, template) ->
    event.preventDefault()

    moneyAccount =
      name: template.find('[data-id=name]').value
      type: template.find('[data-id=type]').value
      description: template.find('[data-id=description]').value

    Meteor.call 'addMoneyAccount', moneyAccount, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'moneyAccounts'
        sweetAlert 'Erfolg', 'Das Konto wurde erfolgreich angelegt', 'success'
