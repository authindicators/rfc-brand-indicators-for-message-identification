
draft-brand-indicators-for-message-identification-latest-00.xml: draft-brand-indicators-for-message-identification-latest.xml
	sed -e 's/draft-brand-indicators-for-message-identification-latest-latest/draft-brand-indicators-for-message-identification-latest-00/' $< > $@
diff-draft-brand-indicators-for-message-identification-latest-.txt.html: draft-brand-indicators-for-message-identification-latest-.txt draft-brand-indicators-for-message-identification-latest.txt
	-$(rfcdiff) --html --stdout $^ > $@
