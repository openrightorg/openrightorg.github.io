# Singing with Csound

*by Don Mahurin, 2010-02-07*

First released, in 1986, CSOUND is a audio programming language used to
model and synthesize sound.

The language contains many opcodes to allow the creation of complex
instruments. One such opcode is the ‘fof’ opcode, which produces
sinusoid bursts and can be used for formant synthesis. Human vowel
sounds can be synthesized using this opcode.

The examples below demonstrate the use of the ‘fof’ opcode to synthesize
singing vowel sounds, acting as an instrument in midi songs.

Csound source used to translate synth voice and choir voice instruments
into ‘fof’ based instrument, while routing other instruments through the
fluid soft synthesizer engine:
[midi\_fluid\_voice.csd](midi_fluid_voice.csd "midi_fluid_voice.csd")

Star Trek midi converted to contain a synth voice instrument:
[startrek\_voice.mid](startrek_voice.mid "startrek_voice.mid")

Result, converted to mp3:
[startrek\_voice.mp3](startrek_voice.mp3 "startrek_voice.mp3")

Created with:

```
csound midi_fluid_voice.csd -F startrek_voice.mid
```

Nirvana “Lithium” midi converted to contain a synth voice instrument:
[lithium\_voice.mid](lithium_voice.mid "lithium_voice.mid")

Result, converted to mp3:
[lithium\_voice.mp3](lithium_voice.mp3 "lithium_voice.mp3") Note that
here, the synth voice instrument is interpreted as a “wah” voice, where
the start of group of notes starts with a “w” ( a short oo sound), and
continued notes produce an “ah” sound.

Created with:

```
csound midi_fluid_voice.csd -F lithium_voice.mid
```

Prerequisits in Ubuntu:

```
sudo apt-get install csound fluid-soundfont-gm
```

Here some other sample midi files generated with GK-2A guitar pickup
that demonstrate a bending voice: (to be played with the above csd)

[donplay5.mid](donplay5.mid "donplay5.mid")

[donplay7.mid](donplay7.mid "donplay7.mid")

[donplay9.mid](donplay9.mid "donplay9.mid")

[donplay11.mid](donplay11.mid "donplay11.mid")

Many thanks to the authors of Csound, and the examples (fofx6.csd,
fluidcomplex.csd) which the above csd builds upon. Thanks also the the
OLPC csound team which also provided useful examples (gm.csd) and
documentation.
