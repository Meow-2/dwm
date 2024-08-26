# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

# dwm version
VERSION = 6.3

# Customize below to fit your system

# paths
PREFIX = /usr/local

X11INC = /usr/include/X11
X11LIB = /usr/lib/X11

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/include/freetype2
# OpenBSD (uncomment)
#FREETYPEINC = ${X11INC}/freetype2

# includes and libs
INCS = -I${X11INC} -I${FREETYPEINC} -I.
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS} -lXrender

# flags
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_C_SOURCE=200809L -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -O2 ${INCS} ${CPPFLAGS}
LDFLAGS  = ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = cc

SRCDIR = src
BUILDIR = build
DOCDIR = docs
ASSETSDIR = assets
SRC = ${SRCDIR}/drw.c ${SRCDIR}/dwm.c ${SRCDIR}/util.c
OBJ = ${BUILDIR}/drw.o ${BUILDIR}/dwm.o ${BUILDIR}/util.o 

all: dwmblocks options dwm

options:
	@printf "\033[32m====================== Build dwm ========================\033[0m\n"
	@echo dwm build options:
	@echo "PREFIX   = ${PREFIX}"
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

${BUILDIR}/%.o: ${SRCDIR}/%.c config.h
	@mkdir -p ${BUILDIR}
	${CC} -c ${CFLAGS} $< -o $@

${OBJ}: config.h

dwm: ${OBJ}
	@mkdir -p ${BUILDIR}/bin
	${CC} -o ${BUILDIR}/bin/$@ ${OBJ} ${LDFLAGS}

dwmblocks:
	@$(MAKE) -C dwmblocks-async PREFIX=$(PREFIX)

clean:
	@$(MAKE) -C dwmblocks-async clean PREFIX=$(PREFIX)
	@printf "\033[32m====================== Clean dwm ========================\033[0m\n"
	rm -rf ${BUILDIR}

install: dwm
	@$(MAKE) -C dwmblocks-async install PREFIX=$(PREFIX)
	@printf "\033[32m===================== Install dwm =======================\033[0m\n"
	install -m 755 -D ${BUILDIR}/bin/dwm ${DESTDIR}${PREFIX}/bin/dwm
	install -m 644 -D <(sed "s/VERSION/${VERSION}/g" ${DOCDIR}/dwm.1) ${DESTDIR}${PREFIX}/share/man/man1/dwm.1
	install -m 755 -D ${ASSETSDIR}/startdwm ${DESTDIR}${PREFIX}/bin/startdwm	
	install -m 755 -D ${ASSETSDIR}/dwm.desktop ${DESTDIR}${PREFIX}/share/xsessions/dwm.desktop

uninstall:
	@$(MAKE) -C dwmblocks-async uninstall PREFIX=$(PREFIX)
	@printf "\033[32m==================== Uninstall dwm ======================\033[0m\n"
	rm -f ${DESTDIR}${PREFIX}/bin/dwm \
	${DESTDIR}${PREFIX}/share/man/man1/dwm.1 \
	${DESTDIR}${PREFIX}/bin/startdwm \
	${DESTDIR}${PREFIX}/share/xsessions/dwm.desktop

.PHONY: all options clean install uninstall
