#
# built using mmark 2.2.10 and xml2rfc 2.44.0
#
# Warnings for "Too long line found" can be safely ignored
#
# One source for syntax of markdown language is here:
#   https://miek.nl/2016/march/05/mmark-syntax-document/#xml-references

VERSION = 02
DOCNAME = draft-brand-indicators-for-message-identification-latest

all: $(DOCNAME)-$(VERSION).txt $(DOCNAME)-$(VERSION).html

$(DOCNAME)-$(VERSION).txt: $(DOCNAME).xml
	@xml2rfc --text -o $@ $<
	@cat .header.txt $@ .header.txt > README.md

$(DOCNAME)-$(VERSION).html: $(DOCNAME).xml
	@xml2rfc --html -o $@ $<

$(DOCNAME).xml: $(DOCNAME).md
	@sed 's/@DOCNAME@/$(DOCNAME)-$(VERSION)/g' $< | mmark   > $@

clean:
	@rm -f $(DOCNAME)-$(VERSION).txt $(DOCNAME)-$(VERSION).html $(DOCNAME).xml
