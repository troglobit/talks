PATH := $(PATH):$(CURDIR)/bin
PORT ?= 8088

srcs := $(wildcard */index.md)
objs := $(srcs:.md=.html)
pdfs := $(srcs:.md=.pdf)

var-revealjs-url := ../reveal.js
var-theme        := solarized
var-history      := true
var-progress     := false

gen-vars = $(foreach v,$(filter var-%,$(.VARIABLES)),-V $(v:var-%=%)=$($(v)))


all: $(objs)

clean:
	rm $(objs)

pdf: $(pdfs)

serve: $(objs)
	@serve.sh $(srcs)

upload: all
	@rsync --exclude=.git -va --delete . troglobit.com:222/var/www/talks.troglobit.com/

%.html: %.md
	pandoc -t revealjs $(call gen-vars) -s $< -o $@

%.pdf: %.md
	pandoc -t beamer $(call gen-vars) -s $< -o $@

.PHONY: all clean serve
