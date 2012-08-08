# The technology to consider.
TECH = radius

# Send email messages as this user.  Please edit it.
FROM = user@example.org

# Send email messages to this working group.  Please edit it.
TO = wg@example.com

# Version of the software.
VERSION = 1.0

all: message.txt

.PHONY: sync
sync:
	@rsync -q -avz --delete ftp.rfc-editor.org::internet-drafts internet-drafts/

#internet-drafts/all_id.txt: sync

list.txt: internet-drafts/all_id.txt
	@./ietf-tech-report $(TECH) > $@

message.txt: top.txt list.txt 
	@cp top.txt $@
	@cat list.txt >> $@

send: message.txt
	@mail -aFrom:$(FROM) -s "Automatic tech report for `date`" $(TO) < message.txt

.PHONY: dist
dist: ietf-tech-report-$(VERSION).tar.gz

ietf-tech-report-$(VERSION).tar.gz: .git
	@git archive --format=tar --prefix=ietf-tech-report-$(VERSION)/ master | gzip > $@

