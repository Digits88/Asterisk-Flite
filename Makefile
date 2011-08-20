#
# Makefile for Asterisk flite application
#

INSTALL=install
ASTLIBDIR=$(INSTALL_PREFIX)/usr/lib/asterisk
MODULES_DIR=$(ASTLIBDIR)/modules
ASTETCDIR=$(INSTALL_PREFIX)/etc/asterisk

CC=gcc
OPTIMIZE=-O2
DEBUG=-g

LIBS+=-lm -lflite -lflite_cmulex -lflite_usenglish -lflite_cmu_us_kal16 -lflite_cmu_us_kal
CFLAGS+=-pipe -fPIC -Wall -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -D_REENTRANT -D_GNU_SOURCE

all: _all
	@echo " +--------- app_flite Build Complete --------+"
	@echo " + app_flite has successfully been built,    +"
	@echo " + and can be installed by running:          +"
	@echo " +                                           +"
	@echo " +               make install                +"
	@echo " +-------------------------------------------+"

_all: app_flite.so

app_flite.o: app_flite.c
	$(CC) $(CFLAGS) $(DEBUG) $(OPTIMIZE) -c -o app_flite.o app_flite.c

app_flite.so: app_flite.o
	$(CC) -shared -Xlinker -x -o $@ $< $(LIBS)

clean:
	rm -f app_flite.o app_flite.so .*.d

install: _all
	$(INSTALL) -m 755 -d $(DESTDIR)$(MODULES_DIR)
	$(INSTALL) -m 755 app_flite.so $(DESTDIR)$(MODULES_DIR)
	@echo " +---- app_flite Installation Complete ------+"
	@echo " +                                           +"
	@echo " + app_flite has successfully been installed.+"
	@echo " + If you would like to install the sample   +"
	@echo " + configuration file run:                   +"
	@echo " +                                           +"
	@echo " +              make samples                 +"
	@echo " +-------------------------------------------+"

samples:
	mkdir -p $(DESTDIR)$(ASTETCDIR)
	for x in *.sample; do \
		if [ -f $(DESTDIR)$(ASTETCDIR)/`basename $$x .sample` ]; then \
			if [ "$(OVERWRITE)" = "y" ]; then \
				if cmp -s $(DESTDIR)$(ASTETCDIR)/`basename $$x .sample` $$x ; then \
					echo "Config file $$x is unchanged"; \
					continue; \
				fi ; \
				mv -f $(DESTDIR)$(ASTETCDIR)/`basename $$x .sample` $(DESTDIR)$(ASTETCDIR)/`basename $$x .sample`.old ; \
			else \
				echo "Skipping config file $$x"; \
				continue; \
			fi ;\
		fi ; \
		$(INSTALL) -m 644 $$x $(DESTDIR)$(ASTETCDIR)/`basename $$x .sample` ;\
	done

ifneq ($(wildcard .*.d),)
   include .*.d
endif
