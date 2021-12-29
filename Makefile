PATH := $(PATH):$(CURDIR)/bin
PORT ?= 8088

srcs := $(wildcard */index.md)
objs := $(srcs:.md=.html)
pdfs := $(srcs:.md=.pdf)

var-revealjs-url := ../reveal.js
var-theme        := night
var-history      := true
var-transition   := linear
#var-progress     := false

gen-vars = $(foreach v,$(filter var-%,$(.VARIABLES)),-V $(v:var-%=%)=$($(v)))
gen-tmpl = $(firstword $(wildcard $(dir $<)template.html template.html))

all: $(objs)

clean:
	rm -f $(objs)

pdf: $(pdfs)

serve: $(objs)
	@serve.sh $(srcs)

upload: all
	@rsync --exclude=.git -va --delete . troglobit.com:222/var/www/talks.troglobit.com/

%.html: %.md
	pandoc -t html5 --template=$(call gen-tmpl) --standalone --section-divs $(call gen-vars) $< -o $@

%.pdf: %.md
	pandoc -t beamer $(call gen-vars) -s $< -o $@

.PHONY: all clean serve
