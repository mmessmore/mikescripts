BINDIR= $(HOME)/bin

install: install-sh

.PHONY: install-sh
install-sh:
	for f in *.sh; do \
		install -m 755 $$f $(BINDIR)/$${f%.sh}; \
	done
