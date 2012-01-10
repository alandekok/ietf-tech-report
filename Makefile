all: mail.txt

.PHONY: sync
sync:
	@rsync -q -avz --delete ftp.rfc-editor.org::internet-drafts internet-drafts/

internet-drafts/all_id.txt: sync

last-call.txt: internet-drafts/all_id.txt
	@perl -ne 'next if !/^draft-ietf-/;next if /^draft-ietf-radext/;next if /^draft-ietf-dime/;next unless /In Last Call/;chop;split;next if ! -f "internet-drafts/$$_[0].txt";print "internet-drafts/",$$_[0],".txt\n";' < $< > $@

radius.txt: last-call.txt
	@grep -l RADIUS `cat $<` | sed 's,internet-drafts/,,' > $@

mail.txt: top.txt radius.txt 
	@cp top.txt $@
	@cat radius.txt | while read file; do \
		y=`echo $$file | sed 's/-..\.txt//'`; \
		echo "$$file  http://datatracker.ietf.org/doc/$$y/" >> $@; \
	 done

.PHONY: send
send:
	@mail -aFrom:aland@freeradius.org -s "RADIUS Documents in Last Call for `date`" aaa-doctors@ietf.org < mail.txt
