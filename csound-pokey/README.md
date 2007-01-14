# Atari Pokey to Csound Conversion

*by Don Mahurin, 2006-12-26*

(Jump to the [Files](#files "#files"), [Quick start](#quick "#quick"),
or [Examples](#examples "#examples") section if you are in a hurry)

Years ago, I had seen Atari 8-bin emulators like atari800.sf.net, and
thought that a good feature to add would be the ability to dump the
Pokey audio chip state in order to be able to playback the music and
sounds later ( possibly enhance the playback as well ). No, not saving a
Wave file, but the Pokey registers themselves. SID files were available
in the C64 realm; the same was bound to be created for the old Atari 8
bit.

Then later Atari SAP files were created, which are dumps of music data
from the games similar to the SID files for the C64. The ASAP collection
provided a big library of old atari sounds and music.

But the SAP files all contained 6502 assembly that actually played the
music. I known that this can allow complex song changes, but for most
every song, just having the sound data would be enough. I didn’t think
that a SAP player should really have to emulate the 6502 (Rather just
the Pokey audio chip).

The SAP Specification described a SAP Type R format, but I saw no
examples of these, and no players supported this.

SAP Type R was described as:

```
TYPE R - Registers. In this type, binary part is not an Atari binary file.
This part contains values that will be directly written to Pokey
registers ($D200-$D208) in 1/50s intervals (or intervals defined
with FASTPLAY tag).
```

I implemented SAP-R support for the asap player/converter and the
atari800 emulator.

I made the following software changes to support SAP Type R.

  - Modified atari800.sf.net to allow dumping audio as SAP Type R.
  - Modified asap.sf.net to allow reading SAP Type R files.
  - Modified asap.sf.net to allow saving SAP Type R rather than Wave
    files.

(see [files](#files "#files") section)

The last two may be of interest to ASMA users, as these together allow
one to convert SAP Files to SAP Type R files.

Now why would you want SAP Type R files? Well, with a SAP Type R file,
you now just have a piece of Music that could be played with a much
simpler player. Note that the space savings of using 6502 SAP files is
not really sigificant. They are both very small. Gzip will make a SAP-R
file smaller than a SAP-6502 file if that is what you want.

But the real reason (for me) to have a SAP-R file is to have a
sound/music file that is easier to directly convert into another music
format.

And that is what you may be looking for, if you have gotten here. Below
is a Perl application that converts a SAP Type R file into a Csound .csd
file. (see [files](#files "#files") section)

There are a couple things not implemented, but for the most part, it
covers most aspects of the Pokey chip.

Some features:

  - instead of square waves, a custom exponential wave is used. (I tried
    to match the wave shown at [Pokey Registers - Acutal
    Waveform](http://www.xmission.com/~trevin/atari/pokey_regs.html "http://www.xmission.com/~trevin/atari/pokey_regs.html")
    first, but that did not sound right, at all)
  - amplitude and frequency are smoothed, to get rid of clicks and harsh
    transitions.
  - Poly17/Poly9 simulated with simple random data.
  - Poly4 and Poly5 work. See the [Poly](#poly "#poly") section to
    understand the challenge of matching the expected pseudo-random
    harmonic patterns.

Missing features:

  - Poly9 is treated the same as Poly17. I don’t know if it should.
  - Poly5+Poly17 is treated the same as Poly17.
  - Poly5+Poly4 is not implemented. See the [Poly](#poly "#poly")
    section.

Todo:

  - I can still hear clicks when using pure sine waves. These need to be
    removed.
  - support Poly5+Poly4. Some games rely on this.
  - Use the orchestra portion of the csound file with realtime data
    input. The sapr2csound orchestra setup should be able to be used in
    realtime with little modification. All that is really needed is to
    convert atari800.sf.net or mame to output compatible realtime score
    data instead of doing pokey emulation. The poly simulation algorithm
    would need to be converted to C. The cound connection could be a
    named pipe of score data, or use libcsound directly (better).
  - Find out what the distribution of Poly5+Poly17 should be.

### Quick start

To convert atari sounds to Csound:
* Get latest ASMA collection from http://asma.atari.org/
* Get latest asap release from http://asap.sf.net/
* Apply asap patch below
* build asap2wav
* Convert SAP file to SAP-R:
```asap2wav -R -o Game.r.sap Game.sap```
* Using sapr2csound below, convert to csd:
```sapr2csound < Game.r.sap > Game.csd```
* Play or convert to wav using csound:
```csound -W Game.csd```

### Files

#### SAP support for ASAP and atari800.sf.net

ASAP patched for SAP-R Read/Write:
http://github.com/dmahurin/asaptools

Atari800 SAP-R dump patch:
[atari800-sapsave.patch](atari800-sapsave.patch "atari800-sapsave.patch")

SAP-R to Csound: [sapr2csound](sapr2csound "sapr2csound")

#### Realtime Csound output in atari800.sf.net

  - [atari800-csound.patch](atari800-csound.patch "atari800-csound.patch")
  - [atari\_csound.c](atari_csound.c "atari_csound.c")
  - [atari\_csound.h](atari_csound.h "atari_csound.h")
  - [atari.orc](atari.orc "atari.orc")

#### SAP-R tools

SAP-R Shrink: [saprshrink](saprshrink "saprshrink")

SAP-R to HEX: [sap2hex](sap2hex "sap2hex")

HEX to SAP-R: [hex2sap](hex2sap "hex2sap")

#### Other

Big endian patch for saplib:
[saplib-1.5.4-endian.patch](saplib-1.5.4-endian.patch "saplib-1.5.4-endian.patch")
### Examples

Below are some examples of a SAP Type-R file, resulting CSound files,
and corresponding mp3 output. They were created from the rendition of J.
S. Bach’s Toccata and Fugue in D Minor, in the game “Gyruss”.

[gyruss.sap](gyruss.sap "gyruss.sap")

[gyruss.csd](gyruss.csd "gyruss.csd")

[gyruss.mp3](gyruss.mp3 "gyruss.mp3")

**Reverb version**

[gyruss-reverb.csd](gyruss-reverb.csd "gyruss-reverb.csd")

[gyruss-reverb.mp3](gyruss-reverb.mp3 "gyruss-reverb.mp3")

### Polynomial simulation

The POKEY uses pseudo-random masks for effects, by using the masks to
remove parts original sound.

The masks are generated by using a polynomial feedback circuit (or
Linear feedback shift register [Linear Feeback Shift
Register](http://en.wikipedia.org/wiki/Linear_feedback_shift_register "http://en.wikipedia.org/wiki/Linear_feedback_shift_register")(LFSR))

See: [De Re Atari - Chapter
7](http://www.atariarchives.org/dere/chapt07.php "http://www.atariarchives.org/dere/chapt07.php")

See: [Atari Pokey Data
Sheet](http://homepage.ntlworld.com/kryten_droid/Atari/800XL/atari_hw/pokey.htm "http://homepage.ntlworld.com/kryten_droid/Atari/800XL/atari_hw/pokey.htm")

The result is a repeating, all encompasing, pattern of numbers. For 4
bits, 1-15, for 5 bits, 1-31, for 9 bits, 1-511, for 17 bits, 1-131071.
While the largest polynomial can be aproximated with random numbers, the
same is not true for the smaller polynomials which generate consistent
harmonics, in a irregular pattern. Note that the mask itself uses only
one bit(the first) of each number for masking.

Each mask pattern, combined with each frequency (using logical at the
occurance a frequency signal) will result in a new pattern for each
frequency. This new pattern will always repeat after N number of cycles,
where N is the size of the original polynomial pattern.

For 4 and 5 bit polynomials the resulting pattern for a frequency can be
represented an integer number (17 or 31 bits), and passed to Csound.
This number can be used to recreate the sound, using 1/15’s or 1/31’s
harmonics for each bit.

For 9 bits, 511 bits is too big obviously using this method, and is not
yet supported. Possibly, it could be supported by folding the pattern
and coming up with a 12 bit or 24 bit pattern approximation. (12 and 24,
because they would match western music harmonies).

For 5+4 polynomials (see audctl), the masks are both appied. The
resulting polynomial pattern would be at most 465 bits long(15 \*31).
Folding could be again used.

For 5+17 polynomials, the resulting pattern is 4063201 bits long. I am
not yet sure how this effects the random sound. It would generally lower
the frequency.
