class Pitch.StreamUpdater
  constructor: (target, data) ->
    changes = _.pairs data.changes

    _.each changes, (change) ->
      attribute = change[0]
      new_value = change[1][1]
      old_value = change[1][0]

      if target[attribute] == old_value
        target[attribute] = new_value
      else
        console.debug "Someone has updated #{attribute} to #{new_value}"
