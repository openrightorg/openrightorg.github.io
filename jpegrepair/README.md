# jpegrepair

by Don Mahurin, 2017-12-22

Do you have JPEG images that have corrupt or missing blocks?

![](corrupt.jpg)

JPEG repair may be able to help

[jpegrepair](https://github.com/dmahurin/jpegrepair "https://github.com/dmahurin/jpegrepair")

JPEG Repair can fix images at the block level, using the following operations:
- Change color components: Y,Cb,Cr
- Insert blocks
- Delete blocks
- Copy relative blocks

## Build

> make

## Usage

> jpegrepair infile OP ...

where OP is: `cdelta` `dest` `insert` `delete` `copy`

## Examples

Increase luminance.

> jpegrepair dark.jpg light.jpg cdelta 0 100

Fix blueish image.

> jpegrepair blueish.jpg fixed.jpg cdelta 1 -100

Insert 2 blocks at position 50:5

> jpegrepair before.jpg after.jpg dest 50 5 insert 2

Delete 1 block at position 63:54, and after that, correct luminance.
Delete 1 block at position 112:0

> jpegrepair corrupt.jpg fixed.jpg dest 63 54 delete 1 cdelta 0 -450 dest 112 0 delete 1

Copy to position 9:35 2x2 blocks from relative block 1:-20 (1 row forward, 20 columns back).

> jpegprepair before.jpg after.jpg  dest 9 35 2 2 copy 1 -20
