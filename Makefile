# Makefile for mkinitcpio

all: doc

install: all
	install -d ${DESTDIR}/sbin
	install -d ${DESTDIR}/lib/initcpio
	install -d ${DESTDIR}/etc

	sed -e 's|CONFIG="mkinitcpio.conf"|CONFIG="/etc/mkinitcpio.conf"|g' \
	    -e 's|FUNCTIONS="functions"|FUNCTIONS="/lib/initcpio/functions"|g' \
	    -e 's|HOOKDIR="hooks"|HOOKDIR="/lib/initcpio/hooks"|g' \
	    -e 's|INSTDIR="install"|INSTDIR="/lib/initcpio/install"|g' \
	    -e 's|PRESETDIR="mkinitcpio.d"|PRESETDIR="/etc/mkinitcpio.d"|g' \
	    < mkinitcpio > ${DESTDIR}/sbin/mkinitcpio

	chmod 755 ${DESTDIR}/sbin/mkinitcpio

	install -D -m644 mkinitcpio.conf ${DESTDIR}/etc/mkinitcpio.conf
	install -D -m755 init ${DESTDIR}/lib/initcpio/init
	install -D -m755 init_functions ${DESTDIR}/lib/initcpio/init_functions
	install -D -m644 functions ${DESTDIR}/lib/initcpio/functions

	install -d ${DESTDIR}/lib/initcpio/hooks
	install -d ${DESTDIR}/lib/initcpio/install
	install -d ${DESTDIR}/etc/mkinitcpio.d

	cp -R hooks/* ${DESTDIR}/lib/initcpio/hooks
	cp -R install/* ${DESTDIR}/lib/initcpio/install
	cp -R mkinitcpio.d/* ${DESTDIR}/etc/mkinitcpio.d

	install -D -m644 mkinitcpio.5.gz ${DESTDIR}/usr/share/man/man5/mkinitcpio.5.gz

doc: mkinitcpio.5.gz

mkinitcpio.5.gz: mkinitcpio.5.txt
	a2x -d manpage -f manpage mkinitcpio.5.txt
	gzip -c --best mkinitcpio.5 > mkinitcpio.5.gz

clean:
	rm -f mkinitcpio.5
	rm -f mkinitcpio.5.gz
	rm -f mkinitcpio.5.xml
