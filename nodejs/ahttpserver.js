// trivial web server, loading local files, or handlers for url prefixes.
var http = require('http'),
fs = require('fs'),
path = require('path');

var ext_type = { ".jpg": "image/jpg", ".html": "text/html" };

// load handlers
var handlers = [];
fs.readdir(__dirname, function (err, files) { if (err) throw err;
  files.forEach( function (file) {
    var match = file.match(/(.*)_handler.js/);
    if(match != null) {
       console.log('loading /' + match[1] + '/ handler');
       handlers[match[1]] = require('./' + file);
    }
  });
});

http.createServer(function (req, res) {
  var pathtop = req.url.split(/[\/\?]/)[1];
  if(handlers[pathtop] !== undefined) {     
      var r = handlers[pathtop].handler(req, res);
      return;
  }
  var dir = __dirname + '/' + req.url.replace('..', '');

  fs.readFile(dir, 'binary', function (err, data) {
    if (err) {
      res.writeHead(404, {'Content-Type': 'text/plain'});
      res.end('404 Not found');
    } else {
      var type = ext_type[path.extname(req.url)];
      res.writeHead(200, (type != undefined) ? {'Content-Type': type} : {});
      res.end(data, encoding='binary');
    }
  });
}).listen(8080);
