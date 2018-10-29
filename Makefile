.SUFFIXES: .tex .pdf


.PHONY: all
all: example.pdf


.PHONY: clean
clean:
	latexmk -C


.tex.pdf:
	latexmk -pdf $<
