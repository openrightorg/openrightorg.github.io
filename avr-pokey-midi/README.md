# Using an Arduino as a Pokey sound MIDI synth

*by Don Mahurin, 2022-05-27*

This project aims to emulate the Atari POKEY chip on an Arduino.

The project started as a curiosity. Previously I had experimented with reproducing POKEY sounds using CSound.
I had the following thoughts.
- I should have documented that Pokey CSound project more, because I did not recognize much of that code.
- Now, some have created POKEY replacement chips using FPGA based solutions or an AVR based solutions, packaged with POKEY pinouts.
- Why can't we just use an unmodified Arduino

Can an Arduino be used to recreate Pokey sound, as used in old Atari 8 bit computers, using primarily just the Arduino SDK (not programming the low level AVR)? The Answer is YES. With some enhancements and some limitations.

For the impatient, here is a link to the resulting project that allows sending POKEY data (as MIDI) to and Arduino Leonardo, and plays 4 channel sound.

https://github.com/dmahurin/arduino_soft_pokey_midi

The project was initially inspired/derived from this post:

https://www.codesd.com/item/arduino-how-to-create-two-or-more-tones-simultaneously-on-a-piezo-buzzer.html

I tried this out on an Arduino Leonardo, and it did in fact sound like the classic 8 bit square wave familiar to some of us.

But to mimic the POKEY, a bit more work would be required. With the POKEY chip, the tone is given as a frequency divider, and distortion/harmonics effects require implementation of a LFSR.

First, let's start with the main frequency divider. The frequency is calculated with Fout = Fin/(AUDF + 1). Where Fin is the base frequency, and Fout is the frequency of the tone.

On a real system, Fin itself is derived from the CPU, divided depending on AUDCTL configuration.  But for simplicity, we will assume the most common configuration, which ends up with approximately a 64Khz Fin (1.78979 MHz / 28). The Arduino has a 16 MHz clock, so with only frequency division, our 64K clock will be 16MHz/256 = 62500. Close enough for now.

For sound effects, the POKEY can generate white noise, motor noises, or other harmonic sounds.
If we skipped the implementation of these sounds, many POKEY sound output would not sound correct, as such sounds are commonly used in game and music output.

The sound effects are generated with Linear Feedback Shift Registers (LFSR), producing repeating psuedorandom binary sequences, with sizes of 4, 5, 9 and 17 bits.

All of the LFSR are assumed to be fed by the base clock (Fin).
This becomes and issue on the Arduino, as we do not have many CPU cycles to output sound.  And if we calculate LFSR's every cycle, then we will not be able to ouptut sound.

We could use lookup tables instead of calculations, but this only could work with 4,5 or perhaps 9 bit LFSR. All values of a 17bit LFSR would not fit.
This is further complicated on the Arduino, as no Modulo instruction exists. So some calculation is required every cycle.

The 17bit LFSR is used for while noise, and skipping cycles does not significantly change the sound.  So we can perform this every 4 or 8 cycles, and it sounds fine.

The 4 and 5 bit LFSR are calculated with functions that assume that they are called every POKEY cycle.
But every cycle does not leave enough time to output audio.
Skipping cycles changes the sound, but without skipping cycles, we run out of cycles and sound skips and is destorted.
For now, it skips cycles, and the sound is not correct.

To try to get more cycles, I implemented 4 and 5 bit LFSR in assembly. It did not help enough.

For now, it skips cycles. Pure sounds sound fine. 4 and 5 bit LFSR/Poly sounds do not, sometimes. Basically, skipping to different points in the LFSR leads to perhaps smaller repeating patterns, but not always.

How could this be corrected in the future?
- more optimizations, perhaps more of the audio processing loop in assembly.
- frequency scaling. The calculation needs to run at a lower frequency and we need to have running counters to provide something like modulo.
- precalculate the simulated repeating patterns according to AUDF, and provide that as data input.

Moving the LFSR full implementation for later, we still have have one small issue. How to get the register values to the board.

There is not much memory on the board, Not enough to hold sounds or much of much time at allow.

We could send register values over serial ...

or ... over MIDI ...

MIDI is nice because the Arduino Leonardo can enumerate as a MIDI device. And even better is that we can actually translate POKEY register values to and from actual MIDI music.  Meaning that we do not need to invent a new way to pack binary data into midi. We can instead translate to and from music files.

AUDF values are translated into MIDI note values, and AUDC values like volume and distortion translate to MIDI velocity and instrument.

The following tool converts Pokey registers (in SAP Type-R) into MIDI in CSV, which can directly translate to/from MIDI with midicsv/csvmidi.

https://github.com/dmahurin/sapr2midicsv

So puting this all together, now you can date a SAP Type-R register capture from and Atari, convert it to MIDI, send the midi to the Arduino, and hear POKEY-like sound.

As a side effect, you could also just use another midi input, like a keyboard and use the Arduino as a POKEY playing MIDI synth.
