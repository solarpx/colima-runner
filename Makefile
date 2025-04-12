PREFIX ?= /usr/local/bin
INSTALL ?= install
INSTALL_PROGRAM ?= $(INSTALL) -m 755
INSTALL_DATA ?= $(INSTALL) -m 644

.PHONY: all install uninstall clean

all:
	@echo "Available commands:"
	@echo "  make install   - Install colima control script"
	@echo "  make uninstall - Uninstall colima control script"

install:
	@echo "Installing colima control script..."
	@# Remove old installation if it exists
	@if [ -f /usr/local/sbin/colima-control ]; then \
		echo "Removing old installation from /usr/local/sbin..."; \
		rm -f /usr/local/sbin/colima-control; \
	fi
	$(INSTALL) -d $(PREFIX)
	$(INSTALL_PROGRAM) scripts/run_colima.sh $(PREFIX)/colima-control
	@echo "Installation complete. You can now use 'colima-control start' or 'colima-control stop'"

uninstall:
	@echo "Uninstalling colima control script..."
	rm -f $(PREFIX)/colima-control
	@# Remove from old location if it exists
	@if [ -f /usr/local/sbin/colima-control ]; then \
		echo "Removing old installation from /usr/local/sbin..."; \
		rm -f /usr/local/sbin/colima-control; \
	fi
	@echo "Uninstallation complete"

clean:
	@echo "Nothing to clean"