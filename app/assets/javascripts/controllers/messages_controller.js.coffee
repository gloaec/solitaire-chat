class Chat.MessagesController extends Batman.Controller
  routingKey: 'messages'

  setUser: =>
    A = @
    unless @get('currentUserId')
      name = prompt("Please state your name")
      Chat.User.load (err, users) =>
        foundUser = false
        for user in users
          if user.get('name') == name
            @set 'currentUserId', user.get('id')
            @set 'currentUser', user
            foundUser = true
            @refreshDeck user.get('deck')
            break
        unless foundUser
          newUser = new Chat.User(name: name)
          newUser.save()
          @set 'currentUserId', newUser.get('id')
          @set 'currentUser', newUser	
          @refreshDeck user.get('deck')
        A.setUserPollingInterval()
        A.setMessagePollingInterval()

  refreshDeck: (deck) =>   
    $('#outputJSON').val(JSON.stringify(deck))
    $('#deck').empty()
    for card in deck
      $img = $('<img/>').attr('src','/assets/'+card.face+'-'+card.suit+'.png')
      $li = $('<li>').addClass('card').append($img)
      $('#deck').append($li)

  setUserPollingInterval: ->
    A = @
    periodicUserMethod = =>
      jQuery.getJSON '/highest_user_id', '', (data, resp) =>
        previousHighestUserId = @get('previousHighestUserId') || 0
        highestUserId = parseInt(data, 10)
        if highestUserId == 0
          Chat.User.clear()
          Chat.User.load {'user_id': A.get('currentUserId')}, (err, results) =>
            @set 'users', results
        if highestUserId > previousHighestUserId
          Chat.User.load {'user_id': A.get('currentUserId')}, (err, results) =>
            @set 'users', results
          @set 'previousHighestUserId', highestUserId
    periodicUserMethod()
    setInterval(periodicUserMethod, 5000)

  setMessagePollingInterval: ->
    A = @
    periodicMessageMethod = =>
      jQuery.getJSON '/highest_message_id', '', (data, resp) =>
        previousHighestMessageId = @get('previousHighestMessageId') || 0
        highestMessageId = parseInt(data, 10)
        if highestMessageId == 0
          Chat.Message.clear()
          Chat.Message.load {'user_id': A.get('currentUserId')}, (err, results) =>
            @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
        if highestMessageId > previousHighestMessageId
          Chat.Message.load {'user_id': A.get('currentUserId')}, (err, results) =>
            @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
          @set 'previousHighestMessageId', highestMessageId
    periodicMessageMethod()
    setInterval(periodicMessageMethod, 5000)

  setNewDeck: ->
    A = @
    jQuery.getJSON '/users/'+@get('currentUserId')+'/new_deck', '', (data, resp) ->
      A.refreshDeck(data.deck)
      Chat.Message.clear()
      Chat.Message.load {'user_id': A.get('currentUserId')},(err, results) =>
        A.set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')

  shuffle: ->
    A = @
    jQuery.getJSON '/users/'+@get('currentUserId')+'/shuffle', '', (data, resp) ->
      A.refreshDeck(data.deck)
      Chat.Message.clear()
      Chat.Message.load {'user_id': A.get('currentUserId')},(err, results) =>
        A.set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')

  importDeck: -> 
    A = @
    @get('currentUser').set('deck', $.parseJSON($('#inputJSON').val()))
    @get('currentUser').save {}, (data, resp) =>
      A.refreshDeck(@get('currentUser').get('deck'))
      $('#inputJSON').val('')
      $('#importModal').modal('hide')
      Chat.Message.clear()
      Chat.Message.load {'user_id': A.get('currentUserId')},(err, results) =>
        A.set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')
	  
  index: (params) ->
    @set 'emptyMessage', new Chat.Message
    @setUser()

  create: =>
    console.log('==============================================')
    @emptyMessage.set 'user_id', @get('currentUserId')
    @emptyMessage.set 'deck', @get('deck')
    @emptyMessage.save =>
      @set 'emptyMessage', new Chat.Message
      Chat.Message.load {'user_id': A.get('currentUserId')},(err, results) =>
        @set 'messages', new Batman.Set(results...).sortedBy('created_at', 'desc')