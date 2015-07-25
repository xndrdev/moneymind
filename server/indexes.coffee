Meteor.startup ->
  Transactions._ensureIndex {
      date: 1
      value: 1
      category: 1
      description: 1
    },
      unique: true
      sparse: true
