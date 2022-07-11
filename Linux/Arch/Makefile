BINDIR = $(HOME)/bin
SHELL_SCRIPTS != ls *.sh | sed 's!^!$(BINDIR)/!;s!\.sh$$!!'

install: install-sh

install-sh: $(BINDIR) $(SHELL_SCRIPTS)

$(BINDIR):
	@mkdir -p "$(BINDIR)"


$(BINDIR)/%: %.sh
	install -m 0755 $< $@
