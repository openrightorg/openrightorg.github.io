## Node.js - development example

*by Don Mahurin, 2014-12-16*

Below is a walkthrough of the development of a simple web server to show
a few aspects of nodejs.

The final example application is one that:

  - Listens/responds to http page requests
  - Tracks external events (input events for this example)
  - Provides event notifications via http EventSource.
  - Also sends events to websockets server

The core of this application is a simple web server.

A significant aspect of nodejs is it’s asynchronous nature which takes
advantage of JavaScript’s first class, anonymous functions. With
nodejs’s style of asynchronous, event based programming, event
callbacks are passed in to functions, often as inline functions. And as
most nodejs library calls are asynchronous, it is not unusual to see
such inline event callbacks nested to describe complex event handling.

A trivial web server is actually the “Hello World” of nodejs.

From nodejs.org:

```
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(8080);
```

Here, a web server is created, and the request callback provides the
incoming request, and the outgoing response object, such that the
program may send a unique response depending on the request parameters.

To extend this to serve files in the same directory, we call readFile,
and the file readFile callback then will then write the http response
created with the file contents.

```
var http = require('http'),
fs = require('fs'),
path = require('path');

var ext_type = { ".jpg": "image/jpg", ".html": "text/html" };

http.createServer(function (req, res) {
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
```

Finally, we extend the server to allow “handlers” to serve requests with
a certain url prefixes.

```
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
       handlers[match[1]] = require('./' + file);
    }
  });
});

http.createServer(function (req, res) {
  var pathtop = req.url.split(/[\/\?]/)[1];
  console.log(pathtop);
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
```

The “handlers” are just nodejs modules (discussed next), in the same
directory as the server. The modules will be called with requests of the
same name (test\_handler will handle /test/aaa and /test?bbb). The
module is expected to export a function named “handler”, which takes the
same arguments as the request handler.

```
exports.handler = function(req, res) { ... }
```

### Modules

Nodejs modules may be loaded using “require()”. Other js files may be
passed to require(), or a folder containing a nodejs package.

In modules, variables are exported by setting the “exports” object.

Example:

mymod.js::

```
exports.hello = function() { console.log('hello') }
```

otherfile.js::

```
var mymod = require('./mymod.js');
mymod.hello();
```

### “var” and “this”

Variable scope, and object context (‘this’) require some explanation.

In JavaScript, variable scope is determined solely by the
placement/scope of function definitions.

Inner functions inherit the scope of parent functions regardless of how
they are called.

Example of scope of variables.

```
var a = 0;
function first() {
  var a = 1;
  var b = 1;
  function second() {
    var a = 2;
    console.log('second: a=' + a + ', b=' + b);
    // a=2, b=1
    setTimeout(function () {
      console.log('second: a=' + a + ', b=' + b);
      // a=2, b=1
    }, 1000);
  }
  second();
  console.log('a=' + a + ', b=' + b);
  // a=1, b=1

}
first();
console.log('a=' + a);
// a=0, b is undefined
```

“this” refers to the object that calls a function, regardless of how it
is defined.

Examples using ‘this’:

```
var Test = {
  n: 0,
  inc: function () {
     this.n ++;
     console.log('n ' + this.n); }
};

Test.inc(); //  this will be Test.

var mytest1 = Object.create(Test);
mytest1.inc(); // this is mytest1

var mytest2 = Object.create(Test);
mytest2.inc(); // this is mytest2
```

If functions are assigned/passed to a different object. “this” will
change.

For example, if the inc() function is saved globally, calling it will
not work, as ‘this’ will be the global object.

```
var inc = Test.inc;
inc();
```

For the same reason, some care needs to be taken with indirect function
calls. setTimeout for instance will call a function after some time. But
as the caller is somewhere else, the following will not work.

```
mytest2.delay_inc = function() { setTimeout(this.inc, 1000); }
mytest2.delay_inc();
```

Instead, “this” can be saved in a var, such that it may be referenced in
the inner function.

```
mytest2.delay_inc = function() {
  var test = this;
  setTimeout(function() { test.inc()}, 1000);
};
mytest2.delay_inc();
```

*In the specific case of setTimeout, ’this’ may be passed as a callback
argument, but this option is not always available for other functions
with callbacks*

```
setTimeout(function(thisobj) { thisobj.inc()}, 1000, this);
```

### Objects

JavaScript allows object oriented programming ( along with other
programming styles ). “Object” meaning something that can have methods
and attributes, and can inherit methods/attributes from other Objects.
Note that there is no “class” definitions of objects. That is a
different style of programming.

#### Object creation

Object can be created/defined directly with JSON (JavaScript Object
Notation)

```
var Dog =  {
  name: 'barky',
  greet: function() { console.log('name is ' + this.name) }
};
Dog.greet();
```

Objects can be created from other objects (used as prototype).

```
var mydog = Object.create(Dog);
mydog.name = 'mydog';
mydog.greet();
```

Objects may be created from object factory functions (called
constructors), using the “new” keyword. In the function ‘this’ will be
set to the newly created object.

```
function ThatDog (name) {
  this.name = name;
  this.greet = function() { console.log('name is ' + this.name) };
}
thatdog = new ThatDog('it');
thatdog.greet();
```

Optionally, these constructors may also use another object as a
prototype.

```
function YourDog (name) {
  this.name = 'super ' + name;
}
YourDog.prototype = Dog;
yourdog = new YourDog('fred');
yourdog.greet();
```

But if you are writing a module, perhaps the best way to expose creation
of objects to the developer is not at all. Instead, consider creating
module interfaces that do not require separate object creation by the
developer.

Nodejs core functions hide object creation, though objects are used
internally.  
For example, for http requests, the request object is created with the
request call, and the response object is passed to the response
callback.

```
var http = require('http');
var req = http.request({host: 'zzz.org', path: '/'}, function(res) {
  res.on('data', function (chunk) {
    console.log('BODY: ' + chunk);
  });
});
req.end();
```

### Web Sockets

Note, that most developers may use ‘ws’ node module for Web Sockets
development.

Here, however, I created and demonstrate a simple implementation, so
that we may learn a little more about Web Sockets.

**ws\_send.js** provides a simple websocket request/reply interface.

**ws.js** is used by ws\_send.js for websocket primitives. There exist
other websocket modules. This was created to gain an understanding what
is really required for a minimal websocket implementation.

Creating a websocket client requests in nodejs can build from a standard
http.request. Looking at **ws\_send.js** or **ws-cli.js**, you will see
than only ‘pack’ and ‘unpack’ functions are the only additional
websocket requirements. Websockets also requires the client to ‘mask’
data (with xor). We use a zero mask, for simplicity (and the security
benefits of sending xor masked data along with the mask is
questionable).

```
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
```

For completeness, a WebSockets server implementation, **ws-server.js**
is also given. Creating a websocket server requires a ‘key\_hash’
function to give a valid response to a clients request, and a ‘mask’
function to unmask client messages.

### EventSource

EventSource is an easy way to receive server events in a web page.

The web page creates the event, and does some action for each
notification.

```
var source1 = new EventSource('/notification');
source1.addEventListener('notification_id', function(ev) {
  console.log(ev.data);
});
```

In our example, we create web page elements to show the events for each
notification.

The server sends the event with Content-Type of “text/event-stream”, and
the content format is “event: EVENT\\ndata: DATA\\n\\n”;

```
if(null !== (match = req.url.match(/\/notification/))) {
    res.writeHead(200,
    {'Content-Type': "text/event-stream",
     'Cache-Control': 'no-cache',
     'Access-Control-Allow-Origin': "*"});
    process.stdin.on('data', function (data) {
      data = data.toString().replace('\n', '');
      res.write("event: " + "notification" + "\n" +'data: ' + data + "\n\n");
    });
}
```

In our example, rather than just a data string, we use JSON, so we can
have additional data attributes.

Summary:

**ahttpserver.js** - generic web server with external request handlers

**dummy\_handler.js** - generate and handle dummy (input) events

**ws\_send.js** - wrapper to provide simple websocket request/reply
interface

**ws.js** - extra functions required to create Web Sockets client or
server

Run with:

```
nodejs ahttpserver.js
```

See the events with the following HTML interface

```
chromium http://localhost:8080/test.html
```
