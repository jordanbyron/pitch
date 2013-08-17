class Pitch.Stream
  constructor: (@scope) ->
    @socket = new WebSocket(this.socketUrl())
    @socket.onmessage = this.onMessage

  socketUrl: ->
    "ws://#{window.location.host}/proposals/#{@scope.id}/stream"

  onMessage: (e) =>
    data = $.parseJSON(e.data)
    @scope.$broadcast('update', data)
