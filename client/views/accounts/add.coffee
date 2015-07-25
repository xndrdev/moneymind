Template.addAccount.events
  'submit [data-id=add-account-form]': (event, template) ->
    event.preventDefault()

    account =
      name: template.find('[data-id=name]').value
      type: template.find('[data-id=type]').value
      description: template.find('[data-id=description]').value

    Meteor.call 'addAccount', account, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        Router.go 'accounts'
        sweetAlert 'Erfolg', 'Das Konto wurde erfolgreich angelegt', 'success'
