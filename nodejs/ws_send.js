var ws = require ('./ws.js');

exports.send = function(url, arg_data, arg_cb) {
   var url = require('url').parse(url);
   var http = require('http');

   var options = { hostname: url.hostname, port: url.port || 80,
       headers: {
         'Connection': 'Upgrade', 'Upgrade': 'websocket',
         'Sec-WebSocket-Key': 'x3JJHMbDL1EzLkh9GBhXDw==',
         'Sec-WebSocket-Version': '13',
       },
       method: 'GET',
       path: url.path, 
   };

   var req = http.request(options);
   req.once('upgrade', function(res, socket, upgradeHead) {
       socket.on('data', function (data) {
           ws.unpack(data, function(data) {
              arg_cb(data);
           });
       });
       if(upgradeHead != '') { socket.emit('data', upgradeHead); }
       socket.end(ws.pack(arg_data, 0));
   });
   req.on('error', function(err) { console.log('ws_send: ' + err); });

   req.end();
};
