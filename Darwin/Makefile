BINDIR = $(HOME)/bin
OS != uname -s

install: $(DISTRO) install-sh

$(BINDIR):
	@mkdir -p "$(BINDIR)"


.PHONY: install-sh
install-sh: $(BINDIR)
	@echo "** Installing $(OS)-specific scripts"
	@-for f in *.sh; do \
		install -m 755 $$f $(BINDIR)/$${f%.sh}; \
	done
