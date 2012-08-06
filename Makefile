# comma-separated list of RFCS
RFCS = 2865,2866,2867,2868,2869,3162,3575,3579,3580,4675,5080,5090,5176,6158

#  Working groups to ignore.
WGS  = radext,dime

# Version of the software.
VERSION = 1.0

all: mail.txt

.PHONY: sync
sync:
	@rsync -q -avz --delete ftp.rfc-editor.org::internet-drafts internet-drafts/

#internet-drafts/all_id.txt: sync

list.txt: internet-drafts/all_id.txt
	@./ietf-draft-scan.pl -r $(RFCS) -W $(WGS) > $@

mail.txt: top.txt list.txt 
	@cp top.txt $@
	@cat radius.txt >> $@

.PHONY: send
send:
	@mail -aFrom:aland@freeradius.org -s "Drafts referencing RADIUS for `date`" aaa-doctors@ietf.org < mail.txt

.PHONY: dist
dist: ietf-draft-scan-$(VERSION).tar.gz

ietf-draft-scan-$(VERSION).tar.gz: .git
	@git archive --format=tar --prefix=ietf-draft-scan-$(VERSION)/ master | gzip > $@

