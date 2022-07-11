# Config
BINDIR := $(HOME)/bin

# Determine OS
# This works on BSD make and GNU make v4+
OS != uname -s

install: $(OS) install-sh

.PHONY: $(OS)
$(OS):
	@echo "** Installing $(OS)-specific scripts"
	$(MAKE) -C $(OS)

.PHONY: install-sh
install-sh:
	@echo "** Installing universal scripts"
	for f in *.sh; do \
		install -m 755 $$f $(BINDIR)/$${f%.sh}; \
	done

