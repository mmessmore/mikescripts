BINDIR = $(HOME)/bin
DISTRO != scripts/distro.sh

install: $(DISTRO) install-sh

$(BINDIR):
	@mkdir -p "$(BINDIR)"


.PHONY: install-sh
install-sh: $(BINDIR)
	@-for f in *.sh; do \
		install -m 755 $$f $(BINDIR)/$${f%.sh}; \
	done

.PHONY: $(DISTRO)
$(DISTRO): $(BINDIR)
	@echo "** Installing $(DISTRO)-specific scripts"
	@if [ -d "$(DISTRO)" ]; then \
		$(MAKE) -C $(DISTRO); \
	else \
		true;\
	fi;
