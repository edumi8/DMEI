# This makefile assumes latexmk location is in the PATH
# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: main.pdf all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: main.pdf

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

#%.tex: %.raw
#	./raw2tex $< > $@

#%.tex: %.dat
#	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

# -f forces latexmk to continue despite errors (useful for glossary warnings)

main.pdf: main.tex
	latexmk -r latexmk.rc -outdir=build -auxdir=build -f -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex || true
	@-mv ./build/main.pdf ./ 2>/dev/null || true
	@if [ ! -f main.pdf ] && [ -f build/main.pdf ]; then cp build/main.pdf main.pdf; fi
	@if [ -f main.pdf ]; then echo "PDF successfully created: main.pdf"; else echo "Error: PDF not created"; exit 1; fi

clean:
	latexmk -r latexmk.rc -outdir=build -auxdir=build -C

clean-all:
	@-rm -Rf `biber --cache` # might return error if files do not exist; this will not work in windows...
	@-rm -rf ./build 2>/dev/null # might return error if files do not exist; this will not work in windows...

# Release target for thesis submission
release:
	@bash release.sh

release-draft:
	@bash release.sh --draft

release-final:
	@bash release.sh --final

# GitHub release targets
github-release:
	@bash release.sh --github-release

github-draft:
	@bash release.sh --draft --github-release

github-final:
	@bash release.sh --final --github-release
