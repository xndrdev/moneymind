Meteor.methods
  signUp: (user) ->
    throw new Meteor.Error(422, 'Email Adresse darf nicht leer sein') unless user.email
    throw new Meteor.Error(422, 'Passwort darf nicht leer sein') unless user.password
    throw new Meteor.Error(422, 'Passwort wiederholen darf nicht leer sein') unless user.passwordConfirmation
    throw new Meteor.Error(422, 'Passwörter stimmen nicht überein') if user.password isnt user.passwordConfirmation

    newUserId = Accounts.createUser email: user.email.toLowerCase(), password: user.password
