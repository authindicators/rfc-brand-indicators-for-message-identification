#
# built using mmark 2.2.10 and xml2rfc 2.44.0
#
# Warnings for "Too long line found" can be safely ignored
#
# One source for syntax of markdown language is here:
#   https://miek.nl/2016/march/05/mmark-syntax-document/#xml-references

VERSION = 10
DOCNAME = draft-brand-indicators-for-message-identification

all: build/$(DOCNAME).xml build/$(DOCNAME)-$(VERSION).txt build/$(DOCNAME)-$(VERSION).html

build/$(DOCNAME)-$(VERSION).txt: build/$(DOCNAME).xml
	@xml2rfc --text -o $@ $<
	@cat .header.txt $@ .header.txt > README.md

build/$(DOCNAME)-$(VERSION).html: build/$(DOCNAME).xml
	@xml2rfc --html -o $@ $<

build/$(DOCNAME).xml: $(DOCNAME).md
	@sed 's/@DOCNAME@/$(DOCNAME)-$(VERSION)/g' $< | mmark   > $@

clean:
	@rm -f build/$(DOCNAME)-$(VERSION).txt build/$(DOCNAME)-$(VERSION).html build/$(DOCNAME).xml
