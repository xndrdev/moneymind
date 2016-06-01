Template.updateMoneyAccount.events
  'submit [data-id=update-money-account-form]': (event, template) ->
    event.preventDefault()

    moneyAccount =
      _id: template.data.moneyAccount._id
      name: template.find('[data-id=name]').value
      type: template.find('[data-id=type]').value
      description: template.find('[data-id=description]').value

    Meteor.call 'updateMoneyAccount', moneyAccount, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'moneyAccounts'
        sweetAlert 'Erfolg', 'Das Konto wurde erfolgreich bearbeitet', 'success'

Template.updateMoneyAccount.helpers
  selectedIfTypeIsBank: (type) ->
    return 'selected' if type is 'bank'

  selectedIfTypeIsCash: (type) ->
    return 'selected' if type is 'cash'
