var ws_send = require('./ws_send.js');

var input = {};
input.handlers = [];
input.add_handler = function(f) { input.handlers.push(f); };
input.run = function() {
  process.stdin.on('data', function (data) {
    data = data.toString().replace('\n', '');
    //console.log('data ' + data);
    data = data.split(' ');
    if(data[1] === undefined) { data[1] = ''; }
 
    for (var f in input.handlers) {
        input.handlers[f](data[0], data[1]);
    }
  });
};

input.add_handler(function(id, val) {
//   console.log(id + " " + val);
   var url = "ws://echo.websocket.org";
//   var url = "ws://localhost:1337";

   ws_send.send(url, '{"id":"' + id + '", "value": "' + val + '"}', function(data) { console.log('WS response ' + data); });
});

input.run();

exports.handler = function(req, res) {
    var match;

    if(null !== (match = req.url.match(/\/notifications/))) {
       res.writeHead(200,
       {'Content-Type': "text/event-stream",
        'Cache-Control': 'no-cache',
        'Access-Control-Allow-Origin': "*"});
       console.log('Type: ID VALUE');
       input.add_handler(function(id, value) {
           res.write("event: " + "notification" + "\n" +
           'data: {"id": "' + id + '", "value": "' + value + '"}' +
           "\n\n");
          console.log('Type: ID VALUE');
       });
    } else {
       res.writeHead(404);
       res.end('404 unknown' + req.url);
       console.log('unknown ' + req.url);
    }
};

