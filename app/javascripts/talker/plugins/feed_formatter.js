Talker.FeedFormatter = function() {
  var self = this;

  var template = '\
    <small class="timestamp"><%= FormatHelper.formatDate(published) %></small> \
    <a href="//<%= source %>/" class="favicon"> \
      <img src="//<%= source %>/favicon.ico" alt="<%= source %>" /> \
    </a> \
    <a href="<%= url %>" class="title"><%= author %>: <%= truncate(title) %></a> \
    <b class="content_tail"><!----></b> \
    <pre class="content"><%= content %></pre>';
  
  self.onMessageReceived = function(event) {
    if (event.feed) {
      Talker.insertMessage(event, _.template(template, event.feed));
      Talker.getLastRow().addClass("feed");
      return false;
    }
  }
};