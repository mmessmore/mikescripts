BINDIR= $(HOME)/bin
SHELL_SCRIPTS != ls *.sh | sed 's!^!$(BINDIR)/!;s!\.sh$$!!'

install: install-sh

install-sh: $(BINDIR) $(SHELL_SCRIPTS)

$(BINDIR)/%: %.sh
	echo install -m 0755 $< $@
