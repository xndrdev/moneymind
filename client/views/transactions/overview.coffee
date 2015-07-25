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

  'click [data-id=reset-filter]': (event, template) ->
    event.preventDefault()

    template.filterDate.set('')
    template.filterAccountId.set('')
    template.filterValue.set('')
    template.filterCategory.set('')
    template.filterDescription.set('')

  'keyup [data-id=filter-date]': _.debounce((event, template) ->
    template.filterDate.set(template.find('[data-id=filter-date]').value)
  , 300)

  'change [data-id=filter-account-id]': _.debounce((event, template) ->
    template.filterAccountId.set(template.find('[data-id=filter-account-id]').value)
  , 300)

  'keyup [data-id=filter-value]': _.debounce((event, template) ->
    template.filterValue.set(template.find('[data-id=filter-value]').value)
  , 300)

  'keyup [data-id=filter-category]': _.debounce((event, template) ->
    template.filterCategory.set(template.find('[data-id=filter-category]').value)
  , 300)

  'keyup [data-id=filter-description]': _.debounce((event, template) ->
    template.filterDescription.set(template.find('[data-id=filter-description]').value)
  , 300)

Template.transactions.helpers
  transactions: ->
    Transactions.find {}
    ,
    sort:
      date: -1

  accounts: ->
    Accounts.find {}
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

  filterDate: ->
    Template.instance().filterDate.get()

  isSelectedAccount: (accountId) ->
    return 'selected' if Template.instance().filterAccountId.get() is accountId

  filterValue: ->
    Template.instance().filterValue.get()

  filterCategory: ->
    Template.instance().filterCategory.get()

  filterDescription: ->
    Template.instance().filterDescription.get()

  isImported: (category) ->
    category is 'import'

Template.transactions.onCreated ->
  @filterDate = new ReactiveVar('')
  @filterAccountId = new ReactiveVar('')
  @filterValue = new ReactiveVar('')
  @filterCategory = new ReactiveVar('')
  @filterDescription = new ReactiveVar('')

  self = @

  self.autorun ->
    self.transactionsSubscriptionHandle = Meteor.subscribe 'transactions', self.filterDate.get(), self.filterAccountId.get(), self.filterValue.get(), self.filterCategory.get(), self.filterDescription.get()
    self.accountsSubscriptionHandle = Meteor.subscribe 'accounts'
