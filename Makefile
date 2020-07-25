PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man

all:
	@echo Run \'sudo make install\' to install Chive.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p chive $(DESTDIR)$(PREFIX)/bin/chive
	@cp -p doc/chive.1 $(DESTDIR)$(MANDIR)/man1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/chive

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/chive
	@rm -rf $(DESTDIR)$(MANDIR)/man1/chive.1*
