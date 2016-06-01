Template.transactions.events
  'click [data-id=remove-transaction]': (event, template) ->
    event.preventDefault()

    transaction =
      _id: @._id

    $(event.target).closest('.row').slideUp 'slow', ->
      Meteor.call 'removeTransaction', transaction, (error) ->
        if error
          sweetAlert 'Oops...', error.reason, 'error'
          $(event.target).closest('.row').slideDown 'slow'

  'click [data-id=open-assign-category-modal]': (event, template) ->
    event.preventDefault()
    $('#assign-category-modal').modal('show')
    template.find('[data-id=modal-transaction-id]').value = @._id

  'submit [data-id=modal-assign-category-form]': (event, template) ->
    event.preventDefault()

    transaction =
      _id: template.find('[data-id=modal-transaction-id]').value
      category: template.find('[data-id=modal-assign-category]').value

    Meteor.call 'updateTransactionCategory', transaction, (error) ->
      if error
        sweetAlert 'Oops...', error.reason, 'error'
      else
        template.find('[data-id=modal-transaction-id]').value = ''
        template.find('[data-id=modal-assign-category]').value = ''
        $('#assign-category-modal').modal('hide')

  'change [data-id=moneyaccount-id]': (event, template) ->
    template.moneyAccountId.set(template.find('[data-id=moneyaccount-id]').value)

Template.transactions.helpers
  transactions: ->
    Transactions.find {}
    ,
    sort:
      date: -1

  moneyAccounts: ->
    MoneyAccounts.find {}
    ,
    sort:
      createdAt: 1

  currentYear: ->
    moment().year()

  currentMonth: ->
    monthNames = [
      'Januar'
      'Februar'
      'März'
      'April'
      'Mai'
      'Juni'
      'Juli'
      'August'
      'September'
      'Oktober'
      'November'
      'Dezember'
    ]
    monthNames[moment().month()]

  sumExpensesCurrentYear: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if moment(element.date).year() == moment().year()
        if element.type is 'expense'
          total += element.value
    accounting.formatMoney(total*(-1))

  sumExpensesCurrentMonth: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if moment(element.date).month() == moment().month() && moment(element.date).year() == moment().year()
        if element.type is 'expense'
          total += element.value
    accounting.formatMoney(total*(-1))

  sumEarningsCurrentYear: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if moment(element.date).year() == moment().year()
        if element.type is 'earning'
          total += element.value
    accounting.formatMoney(total)

  sumEarningsCurrentMonth: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if moment(element.date).month() == moment().month() && moment(element.date).year() == moment().year()
        if element.type is 'earning'
          total += element.value
    accounting.formatMoney(total)

  isImported: (category) ->
    category is 'import'

Template.transactions.onCreated ->
  @moneyAccountId = new ReactiveVar('')
  self = @
  self.autorun ->
    self.transactionsSubscriptionHandle = Meteor.subscribe 'transactions', self.moneyAccountId.get() #, self.filterDate.get(), self.filterMoneyAccountId.get(), self.filterValue.get(), self.filterCategory.get(), self.filterDescription.get()
    self.accountsSubscriptionHandle = Meteor.subscribe 'moneyAccounts'

Template.transactions.onRendered ->
  Template.instance().moneyAccountId.set(Template.instance().find('[data-id=moneyaccount-id]').value)
