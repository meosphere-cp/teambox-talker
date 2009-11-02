function Scroller(options){
  var self = this;
  
  self.options = {
    scrollLimit: 85
  };
  
  self.options = $.extend(self.options, options);
  
  self.scrollToBottom = function(forceScroll){
    if (self.shouldScrollToBottom() || forceScroll){
      window.scrollTo(0, self.getWindowHeight() + self.getScrollHeight());
    }
  }
  
  self.shouldScrollToBottom = function(){
    return (self.getWindowHeight() + self.getScrollOffset() - self.getScrollHeight() + self.getScrollLimit()) > 0
  }
  
  self.getWindowHeight = function(){
    return window.innerHeight || document.body.clientHeight
  }
  
  self.getScrollOffset = function(){
    return window.pageYOffset || document.documentElement.scrollTop  || document.body.scrollTop
  }
  
  self.getScrollHeight = function(){
    return Math.max(document.documentElement.offsetHeight, document.body.scrollHeight) - 25;// + 25 for padding and extra display stuff. 
  },
  
  self.getScrollLimit = function(){
    if (typeof self.options.scrollLimit == 'function'){
      return self.options.scrollLimit(); 
    } else { // assumes integer
      return self.options.scrollLimit;
    }
  }
}