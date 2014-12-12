## Process this file with automake to produce Makefile.in
## Created by Anjuta

ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

SUBDIRS = src po data
PREFIX=/usr

nomeolvides_gitdocdir = $(docdir)-git
nomeolvides_gitdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS

EXTRA_DIST = $(nomeolvides_gitdoc_DATA) intltool-extract.in intltool-merge.in intltool-update.in


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(nomeolvides_gitdocdir)


AM_VALAFLAGS =--pkg sqlite3 -v
