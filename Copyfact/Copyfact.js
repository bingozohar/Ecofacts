var Copyfact = function() {};

Copyfact.prototype = {
  run: function(arguments) {
    arguments.completionFunction({"url": document.URL, "statement": document.getSelection().toString()});
  },
  finalize: function(arguments) {
    // alert shared!
  }
};

var ExtensionPreprocessingJS = new Copyfact
