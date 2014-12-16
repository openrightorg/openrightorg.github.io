var ws = require('./ws.js');

var http = require('http');

var url = require('url').parse(process.argv[2]);
//console.log(process.argv[2]);
var options = {
   hostname: url.hostname, port: url.port, path: url.path,
   //hostname: 'echo.websocket.org', port: 80, path: '/',
   //hostname: 'localhost', port: 1337, path: '/',
   headers: {
         'Connection': 'Upgrade', 'Upgrade': 'websocket',
         'Sec-WebSocket-Key': 'x3JJHMbDL1EzLkh9GBhXDw==',
         'Sec-WebSocket-Version': '13',
   },
   method: 'GET',
};

var req = http.request(options);
req.once('upgrade', function(res, socket, upgradeHead) {
    socket.on('data',  function(data) {
        ws.unpack(data, function(data) {
           console.log('got reply ' + data);
        });
    });
    socket.emit('data', upgradeHead);
    socket.end(ws.pack('test'), 0);
});

req.end();
