BINDIR = $(HOME)/bin
DISTRO != scripts/distro.sh
#SHELL_SCRIPTS != ls *.sh | sed 's!^!$(BINDIR)/!;s!\.sh$$!!'

install: $(DISTRO)

$(BINDIR):
	@mkdir -p "$(BINDIR)"


# install-sh: $(BINDIR) $(SHELL_SCRIPTS)

$(BINDIR)/%: %.sh
	echo install -m 0755 $< $@

.PHONY: $(DISTRO)
$(DISTRO): $(BINDIR)
	@echo "** Installing $(DISTRO)-specific scripts"
	@if [ -d "$(DISTRO)" ]; then \
		$(MAKE) -C $(DISTRO); \
	else \
		true;\
	fi;
	@echo "** Done with $(DISTRO)"
