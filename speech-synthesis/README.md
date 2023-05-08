# Natural sounding open source speech synthesis

*by Don Mahurin, 2023-03-05*

If you have listened to commonly used open source speech synthesis, you may have wondered why it sounds so primitive compared to other systems.

Listening to espeak, for instance, perhaps you thought that little has changed in 10 or 20 years.
Worse than that, you could even compare such speech engines to "SAM" that ran on the Atari or Commodore, 40+ years ago:

https://discordier.github.io/sam/
https://github.com/discordier/sam

But there are modern speech systems which can achieve more natural sounding voices. They are easy to install and relatively fast.

I will show two solutions here, Mimic3 and Coqui, that have the following attributes:
- natural sounding
- open source
- python interface
- command line interface

## Mimic3 TTS

Installation

```
pip3 install mycroft-mimic3-tts
```

Command line use:
```
mimic3 --play-program play 'This is a test.'
```


Python use, setup wrapper TTS class, save this as 'tts-mimic3.py'

```
from mimic3_tts import Mimic3TextToSpeechSystem, Mimic3Settings
import numpy as np

class TTS_mimic3:
	def __init__(self):
		settings = Mimic3Settings();
		settings.voice = 'en_US/ljspeech_low'
		settings.use_deterministic_compute = True
		self._sample_rate = settings.sample_rate
		self.tts = Mimic3TextToSpeechSystem(settings)

	@property
	def sample_rate(self):
		return self._sample_rate

	def text_to_audio(self, text):
		self.tts.begin_utterance()
		self.tts.speak_text(text)
		return [np.frombuffer(data.audio_bytes, dtype=np.int16) for data in self.tts.end_utterance()]

```

In another file, import this file, and instantiate the class

```
import tts-mimic3 as tts
tts = tts.TTS_mimic3()
```

Then create a program to generate and play the resulting speech from text, call it tts.py

```
import sounddevice as sd
import sys

outstream = sd.OutputStream(channels=1, blocksize=1024, dtype='int16', samplerate=tts.sample_rate)

text = ' '.join(sys.argv[1:]) if len(sys.argv) > 1 else "This is a test."
audio = tts.text_to_audio(text, speaker_audio_file='/tmp/b.flac')
outstream.start()
for a in audio:
        outstream.write(a)
outstream.stop()
```

## Coqui TTS

Installation
```
pip3 install TTS
```

Command line use
```
tts --model_name  tts_models/multilingual/multi-dataset/your_tts --speaker_idx female-en-5 --language_idx en --text 'This is a test.'
```

Or if you want it to sound like your voice
```
tts --model_name  tts_models/multilingual/multi-dataset/your_tts --speaker_wav your-voice.wav --text 'This is a test.'
```

Python use
```
from TTS.api import TTS
import numpy as np

class TTS_coqui:
	def __init__(self, model = None):
		if model is None: model = TTS.list_models()[0]
		self.tts =  TTS(model)
		self._sample_rate = 16000

	@property
	def sample_rate(self):
		return self._sample_rate

	def text_to_audio(self, text, speaker = None, language = None, speaker_audio_file = None):
		if speaker is None:  speaker=self.tts.speakers[0]
		if language is None: language=self.tts.languages[0]
		data = self.tts.tts(text, speaker=speaker, language=language, speaker_wav = speaker_audio_file)
		data = (np.array(data) * (2**15) ).astype(np.int16)
		return [ data ]
```

Then import and instantiate this class with the following, and convert to sound with the same calling code as mentioned above

```
import tts-coqui as tts
tts = tts.TTS_coqui()
```

Now you can call one or both of these speech engines from code, and if the provided command line tool is not sufficient, use python above: python3 tts.py hello world.

I hope you are able to use the information here and synthesize more natural sounding speech, both from, the command line and in code.
