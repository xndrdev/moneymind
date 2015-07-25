Template.dashboard.helpers
  sumExpenses: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if element.type is 'expense'
        total += element.value
    accounting.formatMoney(total)

  sumEarnings: (transactions) ->
    total = 0
    transactions.forEach (element, index, array) ->
      if element.type is 'earning'
        total += element.value
    accounting.formatMoney(total)
