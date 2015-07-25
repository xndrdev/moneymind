Template.accounts.events
  'click [data-id=remove-account]': (event, template) ->
    event.preventDefault()

    account =
      _id: @._id

    $(event.target).closest('.row').slideUp 'slow', ->
      Meteor.call 'removeAccount', account, (error) ->
        if error
          sweetAlert 'Oops...', error.reason, 'error'
          $(event.target).closest('.row').slideDown 'slow'
