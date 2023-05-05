# "Small" language models

*by Don Mahurin, 2023-05-05*

At this point, most of you have used Large Language Models for various purposes or for fun.

Some of you may have wondered if you can run a language model on your regular PC.

A few months ago, if you were interested in running a "small" language model on your PC, your options were relatively limited. Perhaps you could have tried an open model RWKV, with something like the rwkvstic project:

https://github.com/harrisonvanderbyl/rwkvstic

That would have allowed you to run a 3B model (B means billions of parameters) with OK performance on your PC.

I actually used RWKV/rwkvstic to create a interactive, speech enabled talk bot in python. But I paused this effort, as rapid development of other language models made this obsolete, as you will see.
It was also a little slow, and the 3B model was somewhat limited.

## Development acceleration

A lot has changed since then, with two major development boosts. One was the release of LLaMa by Meta/Facebook, and the other was the project "llama.cpp".

LLaMa showed what was possible in a relatively small model (Compared to ChatGPT, or GPT4).  LLaMa would then become the basis or inspiration of many other models, like Alpaca and Koala.

Llama.cpp started a C++ port of the inference code to run LlaMa, and had goals to optimize to allow execution on more common hardware, even without a GPU.  Llama.cpp would then implement INT8, INT4 and other optimizations, and continues rapid development and optimizations.

https://github.com/ggerganov/llama.cpp

Llama.cpp now supports many other models. Not just LLaMa.
Supported models include: LLaMa, Alpaca, GPT4All, Vigogne, Koala, OpenBuddy

Llama.cpp/ggml has also inspired other projects to use similar optimizations including rwkv.cpp and bert.cpp

https://github.com/saharNooby/rwkv.cpp

https://github.com/skeskinen/bert.cpp

## How to use a small language model

If you want to try a small language model, at this point, the starting point should be llama.cpp.  It is the most active project and supports the most models.

You can follow the build instructions for llama.cpp, then get a model, then run the model with the chat-13B.sh given in llama.cpp examples.

```
cd llama.cpp
MODEL=koala-7B-4bit-128g.GGML.bin ./example/chat-13B.sh
```

For rwkv.cpp, after you quantize your model ( 4_2, 5_0, 5_1, ...) then run:

```
cd rwkv.cpp
python3 ./rwkv/chat_with_bot.py RWKV-4-Raven-7B-Q4_2.bin
```

## Where to get models

Of course you can get the models from their respective sources, and quantize them yourself using scripts in llama.cpp.

But if you are in more of a hurry, you can find pre-quantized models on 'huggingface' which an AI community site which hosts many AI models.

For example, you can search for for "huggingface koala GGML".

This results in:

https://huggingface.co/TheBloke/koala-13B-GPTQ-4bit-128g-GGML

Bigger models, means more data. Quantizing makes the model smaller at a cost of quality. A 7B or 13B 4bit quantized model should run on your PC.

## Upcoming features in llama.cpp

(also see https://github.com/ggerganov/llama.cpp/discussions/1220 )

### Dynamic quantization

This could give the most optimal size and performance

https://github.com/ggerganov/llama.cpp/issues/1256

### Conversation state save/restore

Saving the state of the conversation can allow starting with a specific and known conversation context and can act as a pseudo tuning

### Training/tuning on your PC

Doing fine tuning of a model currently requires a large GPU or time on cloud GPU service.

Hopefully fine tuning will be brought to more people with a change like this.

https://github.com/ggerganov/ggml/issues/8

## Where is this all headed

( Ignoring the long term impact of AI in this article, though that is an important discussion. )

In the near future, you could easily have an appliance at home that you speak to an ask questions and it answers or even sings. And if this uses a small language model, it could be disconnected from the Internet.

https://github.com/AIGC-Audio/AudioGPT/tree/main

### Embedded Language Models

While big companies can afford giant computers, the real value in AI is when we can have truly smart devices, untethered by the Internet. After all, a robot packed with graphics cards and Terabytes of memory is not a scalable solution.

I think the short term will also include many embedded uses of language models.  Big companies will not be gateways to language models.  We will have language models in our vehicles, in our kitchens, on our phones... For many purposes, consumers do not need to be tied to giant computers in the cloud for conversational AI. Embedded conversational AI will spread to many devices, making our lives and our children's lives more useful.

## Rapid Open development

The development of AI has a history of openness, and that will continue, even without "OpenAI".

Models, by their very nature, are derivative. The question of ownership of the source and the derived material will likely also contribute to a natural openness of development.

The speed of development in open source AI has been quite amazing and will likely not slow down, given the great interest. Open development has also been dramatically reducing the barrier of entry for development, from a hardware requirement perspective.  This is further accelerating open development.

In an internal memo, Google seems to indicate that the open development of AI is the real challenger:

https://www.semianalysis.com/p/google-we-have-no-moat-and-neither
