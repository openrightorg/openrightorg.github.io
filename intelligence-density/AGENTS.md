Write a well-referenced paper on Model Intelligence Density over time into README.md, following the steps below,
considering models from the families: Llama, Falcon, Mistral, Mixtral, Deepseek, Qwen, Gemma, Phi, GPT-OSS, GLM, Bonsai, and Zyphra,
and only considering models that are commonly available in MXFP4, NVFP4, NF4, MLX 4bit, Q4_K_M, or in the case of Bonsai Q_1, Q_1.58 or Q_2.

1. First collect the data to llm.csv, tracking references in REFERENCES.txt.
Data to collect: Model Name, Model Release Date, Model Size (gigabytes) Quantized Model Size, MMLU, MMLU-Pro, MMLU-Redux, SWE-Bench-Pro, LiveCodeBench, MMLU for Quantized (if available), MMLU-Pro 4 quantized (if available), MMLU-Redux for quantized (if available), SWE-Bench-Pro for quantized (if available), LiveCodeBench (if available)
 
2. Correct any llm.csv errors.
 
3. As not all models have the same benchmarks available, we need to correlate the benchmarks.  Create correlate.py that take llm.csv as input, and using the available data, determine the linear correlations for each benchmark to MMLU. We are determining the slope and intercept needed to convert MMLU-Pro, MMLU-Redux and SWE-Bench-Pro to MMLU.
The output should be to_mmlu.csv, and the columns should be: Benchmark name (MMLU,MMLU-Pro,MMLU-Redux,SWE-Bench-Pro), slope, intercept.
 
4. Using llm.csv, to_mmlu.csv and matplotlab, generate density.webp. We calculate density with the negative log of the model's error rate divided by the model size, or -ln(1 - (R/100)) / S, where is R is the MMLU, MMLU-Pro or SWE-Bench-Pro in percent and S is model size in gigabytes.

This graph will have multiple Y axes, MMLU Density, MMLU-Pro Density and a twin axis for SWE-Bench-Pro Density.  To determine overall scale, we first determine the min/max MMLU of all values, using the to_mmlu conversion. The limits of the MMLU Density axis will be determined by applying the density formula to the MMLU min/max.  The limits of the MMLU-Pro Density and SWE-Bench-Pro will be determined by converting from the MMLU min/max values to MMLU-Pro or SWE-Bench-Pro (using the inverse to_mmlu conversion), then applying the density formula. The result should be that all density data is on a comparable scale.
 
5. Write README.md that discusses the increasing model intelligence density over time, referencing the generated image in the paper, referencing the data, detailing the methodology, and listing the references from REFERENCES.txt.
