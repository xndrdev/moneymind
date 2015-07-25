Template.signUp.events
  'submit [data-id=sign-up-form]': (event, template) ->
    event.preventDefault()

    user =
      email: template.find('[data-id=email]').value
      password: template.find('[data-id=password]').value
      passwordConfirmation: template.find('[data-id=password-confirmation]').value

    Meteor.call 'signUp', user, (error) ->
      if error
        if error.message is 'Email already exists. [403]'
          sAlert.error 'Email Adresse bereits vergeben'
        else
          sAlert.error error.reason
      else
        Router.go '/'
