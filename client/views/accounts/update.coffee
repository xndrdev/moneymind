Template.updateAccount.events
  'submit [data-id=update-account-form]': (event, template) ->
    event.preventDefault()

    account =
      _id: template.data.account._id
      name: template.find('[data-id=name]').value
      type: template.find('[data-id=type]').value
      description: template.find('[data-id=description]').value

    Meteor.call 'updateAccount', account, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'accounts'
        sweetAlert 'Erfolg', 'Das Konto wurde erfolgreich bearbeitet', 'success'

Template.updateAccount.helpers
  selectedIfTypeIsBank: (type) ->
    return 'selected' if type is 'bank'

  selectedIfTypeIsCash: (type) ->
    return 'selected' if type is 'cash'
