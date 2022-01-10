PATH := $(PATH):$(CURDIR)/bin
TOP  := $(CURDIR)
PORT ?= 8088

ign  := $(wildcard reveal.js/*.md)
mds  := $(wildcard */*.md)
srcs := $(filter-out $(ign),$(mds))
# fails to convert svgs :-/
nopdf := multicast-intro/multicast-intro.pdf inadyn-intro/inadyn-intro.pdf
pdfs := $(filter-out $(nopdf),$(srcs:.md=.pdf))
# fails layouting :-7
nohtml := finit-core/finit-core.html $(wildcard reveal.js/*.html)
html   := $(filter-out $(nohtml),$(srcs:.md=.html)) $(filter-out $(nohtml),$(wildcard */index.html))
objs   := $(html) $(pdfs)

var-revealjs-url := ../reveal.js
var-theme        := league
var-history      := true
//var-transition   := cube zoom slide linear convex
var-transition   := none
var-progress     := false

gen-vars = $(foreach v,$(filter var-%,$(.VARIABLES)),-V $(v:var-%=%)=$($(v)))
gen-tmpl = $(firstword $(wildcard $(dir $<)template.html template.html))

all: $(objs) index.html

clean:
	rm -f $(objs)

list:
	@echo "TOP : $(TOP)"
	@echo "ign : $(ign)"
	@echo "mds : $(mds)"
	@echo "src : $(srcs)"
	@echo "pdf : $(pdfs)"
	@echo "obj : $(objs)"

index.html:
	@echo "<html><head><title>index</title></head><body>"  > $@
	@echo "<h2>HTML</h2><ul>" >> $@
	@for pres in $(html); do \
		echo "<li><a href=\"$$pres\">`dirname $$pres`</a></li>" >> $@; \
	done
	@echo "</ul><h2>PDF</h2><ul>" >> $@
	@for pres in $(pdfs); do \
		echo "<li><a href=\"$$pres\">`dirname $$pres`</a></li>" >> $@; \
	done
	@echo "</ul></body></html>" >> $@

pdf: $(pdfs)

serve: $(objs)
	@serve.sh $(srcs)

upload: all
	@rsync --exclude=.git --exclude=draft -va --delete --port 222 . troglobit.com:/var/www/talks.troglobit.com/

%.html: %.md
	pandoc -t html5 --template=$(call gen-tmpl) --standalone --section-divs $(call gen-vars) $< -o $@
	[ ! -f $(dir $@)/index.html ] && ln -s $(notdir $@) $(dir $@)index.html

%.pdf: %.md
	(cd $(dir $@) && pandoc --pdf-engine=xelatex -t beamer $(notdir $<) -o $(notdir $@))

.PHONY: all clean serve index.html
