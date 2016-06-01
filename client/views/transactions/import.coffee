Template.importTransactions.events
  'submit [data-id=csv-import-file-form]': (event, template) ->
    event.preventDefault()
    fileInput = template.find('[data-id=csv-import-file]')
    moneyAccountId = template.find('[data-id=moneyaccount-id]').value

    Papa.parse fileInput.files[0],
      header: true
      dynamicTyping: true
      complete: (results) ->

        data =
          results: results
          moneyAccountId: moneyAccountId

        Meteor.call 'importTransactions', data, (error) ->
          if error
            sweetAlert 'Oops...', error.reason, 'error'
          else
            sweetAlert 'Erfolg', 'Alle Datensätze wurden erfolgreich importiert', 'success'
            Router.go 'transactions'
