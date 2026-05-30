.PHONY: all plots clean

all: plots

plots: density_small.webp density_medium.webp density_large.webp density_all.webp

density_small.webp: llm.csv plot_density.py to_mmlu.csv
	python3 plot_density.py --max-params 3.5 --output $@

density_medium.webp: llm.csv plot_density.py to_mmlu.csv
	python3 plot_density.py --min-params 3.5 --max-params 15.0 --output $@

density_large.webp: llm.csv plot_density.py to_mmlu.csv
	python3 plot_density.py --min-params 15.0 --max-params 36.0 --output $@

density_all.webp: llm.csv plot_density.py to_mmlu.csv
	python3 plot_density.py --output $@

clean:
	rm -f density_small.webp density_medium.webp density_large.webp density_all.webp
