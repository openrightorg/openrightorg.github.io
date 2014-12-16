var http = require('http');
var ws = require('./ws.js');
var server = http.createServer();
server.on('upgrade', function (req, socket) {
    socket.write('HTTP/1.1 101 Web Socket Protocol Handshake\r\n' +
        'Upgrade: WebSocket\r\n' +
        'Connection: Upgrade\r\n' +
        'Sec-WebSocket-Accept: ' + ws.key_hash(req.headers['sec-websocket-key']) + '\r\n' +
        '\r\n');
    socket.on('data', function (buff) {
        ws.unpack(buff, function(data) {
            console.log(buff.length + '> ' + data);
            socket.write(ws.pack('repsonse to ' + data), 'binary');
        });
    });
    socket.on('end', function (){socket.end(); console.log('end');});
//    socket.on('close', function (){console.log('close')});
    socket.on('error', function (e){console.log('error ' + e)});
    socket.write(ws.pack('Welcome to the Server!'), 'binary');
});
server.listen(1337);
