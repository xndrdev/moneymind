@setTitle = (title) ->
  base = 'moneymind'
  if title then document.title = title + ' - ' + base else base
