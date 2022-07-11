# Config
BINDIR := $(HOME)/bin

# Determine OS
# This works on BSD make and GNU make v4+
OS != uname -s

SHELL_SCRIPTS != ls *.sh | sed 's!^!$(BINDIR)/!;s!\.sh$$!!'

install: $(OS) install-sh

.PHONY: $(OS)
$(OS): $(BINDIR)
	@echo "** Installing $(OS)-specific scripts"
	@if [ -d "$(OS)" ]; then \
		$(MAKE) -C $(OS); \
	else \
		true;\
	fi;
	@echo "** Done with $(OS)"

install-sh: $(BINDIR) $(SHELL_SCRIPTS)

$(BINDIR)/%: %.sh
	install -m 0755 $< $@

$(BINDIR):
	@mkdir -p "$(BINDIR)"
