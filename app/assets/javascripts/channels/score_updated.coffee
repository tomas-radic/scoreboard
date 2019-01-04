App.score_updated = App.cable.subscriptions.create "ScoreUpdatedChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    courtPublicKeys = JSON.parse($('#court_public_keys').val())

    if data['court_public_key'] in courtPublicKeys
      refreshScores()   # this function to be defined on pages
      # location.reload()
