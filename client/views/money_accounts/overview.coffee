Template.moneyAccounts.events
  'click [data-id=remove-money-account]': (event, template) ->
    event.preventDefault()

    moneyAccount =
      _id: @._id

    $(event.target).closest('.row').slideUp 'slow', ->
      Meteor.call 'removeMoneyAccount', moneyAccount, (error) ->
        if error
          sweetAlert 'Oops...', error.reason, 'error'
          $(event.target).closest('.row').slideDown 'slow'
