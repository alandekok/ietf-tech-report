# The technology to consider.
TECH = radius

# Send email messages as this user.  Please edit it.
FROM = user@example.org

# Send email messages to this working group.  Please edit it.
TO = wg@example.com

# Version of the software.
VERSION = 1.0

all: mail.txt

.PHONY: sync
sync:
	@rsync -q -avz --delete ftp.rfc-editor.org::internet-drafts internet-drafts/

#internet-drafts/all_id.txt: sync

list.txt: internet-drafts/all_id.txt
	@./ietf-tech-report $(TECH) > $@

mail.txt: top.txt list.txt 
	@cp top.txt $@
	@cat radius.txt >> $@

send: mail.txt
	@mail -aFrom:$(FROM) -s "Automatic tech report for `date`" $(TO) < mail.txt

.PHONY: dist
dist: ietf-tech-report-$(VERSION).tar.gz

ietf-tech-report-$(VERSION).tar.gz: .git
	@git archive --format=tar --prefix=ietf-tech-report-$(VERSION)/ master | gzip > $@

