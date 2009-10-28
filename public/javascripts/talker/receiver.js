// 1) Handles incoming events, messages, notices and errors in the browser log.
// 2) Updates list of users in the chat room..
Receiver = {
  // handles all incoming messages in a triage fashion eventually becoming an insertion in the log
  push: function(data, replay, index) {
    if (data.type == null) return;
    
    data.time = data.time + currentUser.time_zone_offset;

    if (typeof Receiver[data.type] == 'function'){
      if ($.inArray(data.type, ['message', 'notice']) > -1 && $('#log p:last[time]').attr('time') - data.time < -(5 * 60)){
        Receiver.timestamp(data, replay);
      }
      Receiver[data.type](data, replay);
      if (!replay) ChatRoom.scroller.scrollToBottom();
    }else{
      console.info(JSON.encode(data, replay, index));
      console.error("*** Unable to handle data type: (" + data.type + ") with data.  Format may not be appropriate.");
    }
  },
  
  connected: function(data, replay) {
    $('#msgbox').focus();
  },
  
  join: function(data, replay) {
    UserList.add(data.user, replay);
    
    var element = $('<tr/>').attr('author', data.user.name).addClass('received').addClass('notice').addClass('user_' + data.user.id).addClass('event')
      .append($('<td/>').addClass('author'))
      .append($('<td/>').addClass('message')
        .append($('<p/>').attr('time', data.time).html(data.user.name + ' has entered the room')));
    
    element.appendTo('#log');
  },
  
  leave: function(data, replay) {
    UserList.remove(data.user, replay);
    
    var element = $('<tr/>').attr('author', data.user.name).addClass('received').addClass('notice').addClass('user_' + data.user.id).addClass('event')
      .append($('<td/>').addClass('author'))
      .append($('<td/>').addClass('message')
        .append($('<p/>').attr('time', data.time).html(data.user.name + ' has left the room')));
    
    element.appendTo('#log');
  },
  
  close: function(data, replay){

  },
  
  back: function(data, replay) {
    $("#user_" + data.user.id).css('opacity', 1.0).removeClass('idle');
  },
  
  idle: function(data, replay) {
    $("#user_" + data.user.id).css('opacity', 0.5).addClass('idle');
  },
  
  message: function(data, replay, index) {
    // we need to figure out if the last row is of the same author to group elements together.
    var last_row    = $('#log tr:last');
    var last_author = last_row.attr('author');
    
    // console.info(last_row);
    // data.content = FormatHelper.timestamp2date(data.time) + " " + data.content;
    
    // format content appropriately
    if (data.paste && data.paste != 'null'){
      data.content = FormatHelper.formatPaste(data);
    } else {
      data.content = FormatHelper.text2html(data.content);
    }
    
    if (last_author == data.user.name && last_row.hasClass('message')){ // only append to existing blockquote group
      last_row.find('blockquote')
        .append($('<p/>').attr('time', data.time).html(data.content));
    } else {
      var element = $('<tr/>').attr('author', data.user.name).addClass('received').addClass('message').addClass('user_' + data.user.id).addClass('event').addClass(data.user.id == currentUser.id ? 'me' : '')
        .append($('<td/>').addClass('author')
          .append('\n' + data.user.name + '\n')
          .append($('<img/>').attr('src', '/images/avatar_default.png').attr('alt', data.user.name).addClass('avatar'))
          .append($('<b/>').addClass('blockquote_tail').html('<!-- display fix --->')))
        .append($('<td/>').addClass('message')
          .append($('<blockquote/>')
            .append($('<p/>').attr('time', data.time).html(data.content))));

      element.appendTo('#log');
    }
  },
  
  timestamp: function(data, replay){
    var element = $('<tr/>').addClass('timestamp')
      .append($('<td/>')
        .html(FormatHelper.toHumanDate(data.time)))
      .append($('<td/>')
        .append($('<p/>').attr('time', data.time)
          .html(FormatHelper.toHumanTime(data.time))));

    element.appendTo('#log');
  }
}

UserList = {
  add: function(user, replay){
    if ($("#user_" + user.id).length < 1) {
      var presence = $('<li/>').attr("id", "user_" + user.id)
        .html('<img alt="gary" src="/images/avatar_default.png" />' + user.name)
        .appendTo($('#people'));
        
      if (replay){
        presence.css('opacity', 1.0);
      } else {
        presence.animate({opacity: 1.0}, 800);
      }
    }
  },
  
  remove: function(user, replay){
    if (replay){
      $("#user_" + user.id).remove();
    } else {
      $("#user_" + user.id).animate({opacity: 0.0}, 800, function(){ $(this).remove() });
    }
  }
}