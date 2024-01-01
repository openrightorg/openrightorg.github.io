# Training a large language model ... in reverse

*by Don Mahurin, 2023-12-31*

## Basic Training

When training a language model, training data is repeatedly fed into the model, and the predictions are compared against the expected result. The resulting prediction error is used to update the model weights using a method like gradient descent.

## Training with TinyStories data

The script 'train.py' provided as part of the 'llama2.c' project, allows training for a Llama model using the TinyStories data set. The TinyStories data contains many children's stories and allows synthesis of similar new stories.

The following is how one would train using TinyStories:

```
python3 tinystories.py download
python3 tinystories.py pretokenize
python3 train.py
```

And given a day or so on a Mac M1/M2 or comparable machine, this would result in model weight than can be used to create stories, starting with a few words as the initial input, the resulting model weights would be like the pre-generated weights at:

https://huggingface.co/karpathy/tinyllamas

Then one can generate a story, starting with text like "There was once a dog who..." or "In a small town there was a boy...".

## Reverse training and inference

But what if instead of starting with the beginning text, we wanted to start with the <u>end</u> of the story.  We could use existing pre-trained model weights, because those weight are trained to predict the <u>next</u> token/work.  To start at the end, we need to predict the previous word.

We can accomplish this by reversing the training data, and then when the inference is ran, the result is reversed again.

## Training

In order to use the same tokenizer vocabulary, we should only reverse the order of the words, not the words themselves.  And in order to maintain the sentence order (in reverse), we reverse the punctuation along with the words.

for this change, we modify tinystories.py with:

```
text = ''.join(reversed(re.split('([\w\d\']+|\.|"|\?|\!|,)', text)))
```

Training with such a modification will result in a model like:

https://huggingface.co/openright/tinyllamas-reversed

## Reversed Inference

The input tokens are expected in reverse, and the output tokens are also in reverse. For example, "This is a test.", becomes ".test a is This".

We can simply run with reversed input, and see the reversed output.

```
./run  revstories15M.bin -s 3 -i '.sky the in butterfly'
```

> .sky the in butterfly purple beautiful the about family her tell
> ...

But to have the input and output unreversed, we can use the 'wtac' script to reverse the words.

```
./run  revstories15M.bin -s 3 -i "$(echo 'butterfly in the sky.' | python3 wtac.py)" | python3 ./wtac.py
```

> Once upon a time, there was a little girl named Lily. She loved to play in the park with her friends. One day, the butterfly landed on Lily's hands and led her to a flower. Lily was very happy and couldn't wait to tell her family about the beautiful purple butterfly in the sky.

## Conclusion

While the results are interesting, the reverse inference seems like it needs more work, compared to the same sized training for forward inference. It took a few tries to come up with a story that sticks together a little.
Perhaps it was the number of iterations (100K vs 298K for tinyllamas), or perhaps there is another issue with the reversed word training.

The result is still promising and worthy of more investigation. Perhaps someone is inspired to reverse train with a large data set.
