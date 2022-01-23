PATH := $(PATH):$(CURDIR)/bin
TOP  := $(CURDIR)
PORT ?= 8088

ign  := $(wildcard reveal.js/*.md)
mds  := $(wildcard */*.md)
srcs := $(filter-out $(ign),$(mds))
# fails to convert svgs :-/
#nopdf := multicast-intro/multicast-intro.pdf inadyn-intro/inadyn-intro.pdf
pdfs := $(filter-out $(nopdf),$(srcs:.md=.pdf))
# fails layouting :-7
# finit-core/finit-core.html
nohtml :=  $(wildcard reveal.js/*.html)
html   := $(filter-out $(nohtml),$(srcs:.md=.html))
objs   := $(html) $(pdfs)

var-revealjs-url := ../reveal.js
var-theme        := wiberg
var-history      := true
#var-transition   := cube zoom slide linear convex
var-transition   := none
var-progress     := false

gen-vars = $(foreach v,$(filter var-%,$(.VARIABLES)),-V $(v:var-%=%)=$($(v)))
gen-tmpl = $(firstword $(wildcard $(dir $<)template.html template.html))

all: $(objs) index.html

clean:
	rm -f $(objs)
	find . -maxdepth 2 -name index.html -type l -delete

list:
	@echo "TOP : $(TOP)"
	@echo "ign : $(ign)"
	@echo "mds : $(mds)"
	@echo "src : $(srcs)"
	@echo "pdf : $(pdfs)"
	@echo "obj : $(objs)"
	@echo "html: $(html)"

index.html:
	@echo "<!DOCTYPE html>" > $@
	@echo "<html lang=\"en-US\"><head><meta charset=\"utf-8\"><title>index</title>" >> $@
	@echo "  <meta name=\"apple-mobile-web-app-capable\" content=\"yes\">" >> $@
	@echo "  <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black-translucent\">" >> $@
	@echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, minimal-ui\">" >> $@
	@echo "<link rel=\"stylesheet\" href=\"/reveal.js/css/reveal.css\">" >> $@
	@echo "<style type=\"text/css\">"  >> $@
	@echo "     code{white-space: pre-wrap;}" >> $@
	@echo "     span.smallcaps{font-variant: small-caps;}" >> $@
	@echo "     span.underline{text-decoration: underline;}" >> $@
	@echo "     div.column{display: inline-block; vertical-align: top; width: 50%;}" >> $@
	@echo "</style>" >> $@
	@echo "<link rel=\"stylesheet\" href=\"/reveal.js/css/theme/wiberg.css\"></head><body>" >> $@
	@echo "  <div class=\"reveal\"><div class=\"slides\">" >> $@
	@echo "   <section id=\"title-index\" class=\"slide level2\">">> $@
	@echo "<h1>talks.troglobit.com</h1>" >> $@
	@echo "   <div class=\"columns\"><div class=\"column\" style=\"width:50%;\">" >> $@
	@echo "<h2>HTML</h2><ul>" >> $@
	@for pres in $(html); do \
		dir=`dirname $$pres`; \
		echo "<li><a href=\"/$$dir/\">$$dir</a></li>" >> $@; \
	done
	@echo "</ul></div><div class=\"column\" style=\"width:50%;\">" >> $@
	@echo "<h2>PDF</h2><ul>" >> $@
	@for pres in $(pdfs); do \
		echo "<li><a href=\"/$$pres\">`dirname $$pres`</a></li>" >> $@; \
	done
	@echo "</ul></div></div></section></div></div>" >>$@
	@echo "  <script src=\"/reveal.js/lib/js/head.min.js\"></script>" >>$@
	@echo "  <script src=\"/reveal.js/js/reveal.js\"></script>"  >>$@
	@echo "  <script>" >> $@
	@echo "" >> $@
	@echo "      // Full list of configuration options available at:" >> $@
	@echo "      // https://github.com/hakimel/reveal.js#configuration" >> $@
	@echo "      Reveal.initialize({" >> $@
	@echo "        // Display a presentation progress bar" >> $@
	@echo "        progress: false," >> $@
	@echo "        // Push each slide change to the browser history" >> $@
	@echo "        history: true," >> $@
	@echo "        // Transition style" >> $@
	@echo "        transition: 'none', // none/fade/slide/convex/concave/zoom" >> $@
	@echo "" >> $@
	@echo "        // Optional reveal.js plugins" >> $@
	@echo "        dependencies: [" >> $@
	@echo "          { src: '../reveal.js/lib/js/classList.js', condition: function() { return !document.body.classList; } }," >> $@
	@echo "          { src: '../reveal.js/plugin/zoom-js/zoom.js', async: true }," >> $@
	@echo "          { src: '../reveal.js/plugin/notes/notes.js', async: true }" >> $@
	@echo "        ]" >> $@
	@echo "      });" >> $@
	@echo "    </script>" >> $@
	@echo "</body></html>" >> $@

pdf: $(pdfs)

serve: $(objs)
	@serve.sh $(srcs)

upload: all
	@rsync --exclude=.git --exclude=draft -va --delete --port 222 . troglobit.com:/var/www/talks.troglobit.com/

#	pandoc -t html5 --template=$(call gen-tmpl) --standalone --section-divs $(call gen-vars) $< -o $@
%.html: %.md
	pandoc -t revealjs -s $(call gen-vars) -o $@ $^
	[ -f $(dir $@)index.html ] || ln -sf $(notdir $@) $(dir $@)index.html

# Beamer speaker notes: -V classoption=notes 
%.pdf: %.md
	(cd $(dir $@) && pandoc -s --pdf-engine=xelatex -t beamer $(notdir $<) -o $(notdir $@))

.PHONY: all clean serve index.html
