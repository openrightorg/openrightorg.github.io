# Efficiency of language models (in bananas)

*by Don Mahurin, 2024-07-28*

To see how efficient language model processing is, let’s compare – with
the human brain.
To make the comparison relatable, let’s use energy contained in a banana
(100 Calories) to make such a comparison.

Bananas used per day:

| Human brain     | 3      | ![](banana3.webp)  |
| :---- | :---- | :---- |
| AMD Radeon RX 6600  | 32 | <img src="banana30.webp" style="height: 25; width: 29; object-fit: none; object-position: 0 0"/> |
| Nvidia RTX 3090 | 72  |  ![](banana60.webp) |
| Nvidia DGX 8xH100     | 1156 | ![](banana100.webp) ![](banana100.webp) ![](banana100.webp)  ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana100.webp) ![](banana60.webp) |

That's a lot of bananas.

And though this may not be an apples to apples comparison, there is potentially still a
large efficiency gap when compared to the brain. And an even larger gap if we consider learning/training.

The gap will likely continue to narrow, and with this will come many changes
in application, devices and models.

## Why LLMs must get more efficient

Efficiency will guide AI development, especially as we leave the server room.

- Smart Robots cannot be tethered to network or GPU rack  ![](bot-tethered.webp)
- Personal AI - more human connected, more personal data, and will likely require capable private/local models.
- Embedded AI - your kitchen LLM does not need to know car repair.

## Short term advances (software)

Even in the near term, language models processing efficiency can be significantly better, even with existing technology, such as:

- Ternary models - 1/10th the size of fp16/bf16, 4x speedup and reduction in power and cost.
- LLMs in a flash - offload sparse feed forward parts to flash or lower speed storage
  - 1/2 memory requirements 4-20x speedup
- Transformer architecture alternatives could have a potential 5x performance gain.

Consider running a model similar to Llama 3.1 405B in 80G or 40G of memory or less.

## Conclusions

There are real use cases for embedded/personal language models, and this will drive more efficient
hardware and software.
There is plenty of room for efficiency improvements, especially comparing to the human brain.
Even focusing on the near term, significant improvements can already be made with existing technology.
Such advances can help AI be more useful at a personal and human level.
