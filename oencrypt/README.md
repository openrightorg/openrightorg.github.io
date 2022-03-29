# OEncrypt

*by Don Mahurin, 2022-03-29*

OEncrypt is an ecryption interface that may run in a browser or on the command line.

The command line tool, 'oenc' is compatible with a subset of the openssl command line tool, (openssl enc ...).

OEncrypt is written in JavaScript and utilizes the Web Crypto API.

https://github.com/dmahurin/oencrypt

## Purpose

The purpose of OEncrypt is to provide a mechanism to ecrypt files, and allow dynamic decryption in a Browser.

The Web Crypto API does provide interfaces to allow general encryption and decryption, but a user/developer cannot just take a commonly encrypted file (using openssl ..), and easily use the decrypted content in a browser.

OEncrypt implements both encryption and decryption in the same interface. Having a single portable Javascript code base allows function in Browser JavaScript and command line NodeJS Javascript. Having Encryption and decryption in the same library/interface also facilitates extensions to support more than just openssl compatible encryption.

OEncrypt provides:
- Programing interface portable to browser or nodejs, as long as the Web Crypto API is implemented.
- 'oenc' command line tool, compatible with openssl command line encryption, using PBKDF2 derived keys, and AES-256 encryption.
- AES wrapped keys, allowing the key to be password protected.
- Alternatively, allow use of a offset "key", which also allows password protection of the key

## OpenSSL encryption, OEncrypt decryption

Using Oencrypt/oenc, you may decrypt files encrypted with openssl using aes-256 (ctr or cbc).

```
echo validate | openssl enc -aes-256-ctr -pbkdf2 -pass pass:test -iter 10000 | \
./oenc -aes-256-ctr -pass test
```

## Encryption/Decryption of AES wrapped keys

Often, it is desired to encrypt the keys so that the the user must also need to use a key to use the key.

The example below shows how Oencrypt/oenc may be used to use AES encrypted keys.

```
key="$(./oenc -genkey -pass test)"
echo validate | ./oenc -key "$key" -pass test -base64 | \
./oenc -key "$key" -pass test -base64 -d
```

## Encryption on command line decryption in browser

OEncrypt may be used to encrypt files offline, and then decrypt and use them in a browser.

For example, the bottom of this page contains an encrypted image.

https://dmahurin.github.io/oencrypt/test.html

The image is encrypted with the following encrypted key encoded as Base64.

```
3sQ1pfudQvgW8+vAaGVpSSv18yiucLTLEVVDg8x+/PxNehTuvuueVw==
```

The key is encrypted with the passphrase 'test'.

If you enter import this key (which is entered by default in the page), and enter the password 'test', the image will appear. Concentric boxes.

