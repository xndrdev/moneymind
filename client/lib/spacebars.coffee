UI.registerHelper 'formatDate', (date) ->
  moment(date).format('L')

UI.registerHelper 'formatNumber', (number) ->
  accounting.formatMoney(number)

UI.registerHelper 'formatNumberForInput', (number) ->
  accounting.formatNumber(number, 2, ".", ",");
