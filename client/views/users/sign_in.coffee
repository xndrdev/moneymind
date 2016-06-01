Template.signIn.events
  'submit [data-id=sign-in-form]': (event, template) ->
    event.preventDefault()

    email = template.find('[data-id=email]').value
    password = template.find('[data-id=password]').value

    if not email
      sAlert.error i18n 'emailIsBlank'
    else if not password
      sAlert.error i18n 'passwordIsBlank'
    else
      Meteor.loginWithPassword email.toLowerCase(), password, (error) ->
        if error
          sAlert.error i18n 'emailOrPasswordIsWrong' if error.message is 'Incorrect password [403]' or error.message is 'User not found [403]'
        else
          Router.go '/'

Template.signIn.onCreated ->
  # if the user has requested a new password
  if Accounts._resetPasswordToken
    Router.go 'newPassword'
