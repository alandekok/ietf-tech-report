all: to-review.txt

.PHONY: sync
sync:
	@rsync -q -avz --delete ftp.rfc-editor.org::internet-drafts internet-drafts/

internet-drafts/all_id.txt:

last-call.txt: internet-drafts/all_id.txt
	@perl -ne 'next if !/^draft-ietf-/;next if /^draft-ietf-radext/;next if /^draft-ietf-dime/;next unless /In Last Call/;chop;split;next if ! -f "internet-drafts/$$_[0].txt";print "internet-drafts/",$$_[0],".txt\n";' < $< > $@

radius.txt: last-call.txt
	@grep -l RADIUS `cat $<` > $@
