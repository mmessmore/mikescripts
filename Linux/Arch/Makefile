BINDIR = $(HOME)/bin

install: install-sh

$(BINDIR):
	@mkdir -p "$(BINDIR)"


.PHONY: install-sh
install-sh: $(BINDIR)
	@- for f in *.sh; do \
		install -m 755 $$f $(BINDIR)/$${f%.sh}; \
	done
