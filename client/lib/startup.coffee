Meteor.startup ->
  moment.locale 'de'

  accounting.settings =
    currency:
      symbol: '€'
      format: '%v%s'
      decimal: ','
      thousand: '.'
      precision: 2
    number:
      precision: 0
      thousand: '.'
      decimal: ','
