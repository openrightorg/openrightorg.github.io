exports.mask = function(data, mask) {
    if(mask !== undefined && mask.length > 0) {
        var i; for (i = 0; i < data.length; i++) {
            data[i] = data[i] ^ mask[i % 4];
        }
    }
    return data;
};

exports.pack = function(data, masknum) {
   var lenbuf;
   var maskbit = (masknum !== undefined)?0x80:0;
   if(data.length <= 0x7d) {
     lenbuf = new Buffer( [ data.length | maskbit ]);
   } else if (data.length <= 0xffff) {
     lenbuf = new Buffer(4);
     lenbuf.writeUInt8(0x7e | maskbit, 0);
     lenbuf.writeUInt16BE(data.length, 1);
   } else {
     console.log('not supported');
     return undefined;
   }
   var mask; if (masknum !== undefined) { mask = new Buffer(4); mask.writeUInt32BE(masknum, 0); } else { mask = new Buffer(0); }

   return Buffer.concat([ new Buffer( [ 0x81 ]), lenbuf, mask, exports.mask(new Buffer(data, 'utf8'), mask)]);
};

exports.unpack = function (data, cb) {
  while(data.length > 0) {
    if(data[0] & 0x1) {
      var len = data[1] & 0x7f;
      var masked = data[1] & 0x80;
      if (len == 0x7f && data.readUInt32(2) > 0) { console.log('unsupported'); return; }
      else if (len == 0x7f) { offset = 10; len = data.ReadInt32(6); }
      else if (len == 0x7e) { offset = 4; len = data.readUInt16(2); }
      else { offset = 2; }
      var mask;
      if(masked) { mask = data.slice(offset, (offset+=4)); }
      var data1 = new Buffer(data.slice(offset, offset + len));
      if(data1.length < len) { console.log('short data length'); break; }
      if(masked) data1 = exports.mask(data1, mask);
      cb(data1);
      data = data.slice(offset+len);
    } else { console.log('unexpected data ' + data[0].toString(16)); break; }
  }
};

exports.key_hash = function (key) {
    var crypto = require('crypto');

    var hash = crypto.createHash('sha1');
    var $GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
    hash.update(key + $GUID, 'utf8');
    return hash.digest('base64');
};

