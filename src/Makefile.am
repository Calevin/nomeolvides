## Process this file with automake to produce Makefile.in

## Created by Anjuta

AM_CPPFLAGS = \
	-include config.h \
	$(NOMEOLVIDES_CFLAGS) \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\"

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = nomeolvides-git

nomeolvides_git_SOURCES = \
	config.vapi \
	nomeolvides-acciones-db.vala \
	nomeolvides-app.vala \
	nomeolvides-archivo.vala \
	nomeolvides-base-de-datos.vala \
	nomeolvides-base.vala \
	nomeolvides-boton.vala \
	nomeolvides-coleccion.vala \
	nomeolvides-configuracion.vala \
	nomeolvides-datos.vala \
	nomeolvides-deshacer-item.vala \
	nomeolvides-deshacer.vala \
	nomeolvides-dialog-archivo-abrir.vala \
	nomeolvides-dialog-archivo-guardar.vala \
	nomeolvides-dialog-base-borrar.vala \
	nomeolvides-dialog-base.vala \
	nomeolvides-dialog-coleccion-agregar.vala \
	nomeolvides-dialog-coleccion-borrar.vala \
	nomeolvides-dialog-coleccion-editar.vala \
	nomeolvides-dialog-coleccion.vala \
	nomeolvides-dialog-hecho-agregar.vala \
	nomeolvides-dialog-hecho-borrar.vala \
	nomeolvides-dialog-hecho-editar.vala \
	nomeolvides-dialog-hecho-lista-agregar.vala \
	nomeolvides-dialog-hecho-lista-borrar.vala \
	nomeolvides-dialog-hechos-importar.vala \
	nomeolvides-dialog-hecho.vala \
	nomeolvides-dialog-lista-agregar.vala \
	nomeolvides-dialog-lista-borrar.vala \
	nomeolvides-dialog-lista-editar.vala \
	nomeolvides-dialog-lista.vala \
	nomeolvides-dialog-migrador.vala \
	nomeolvides-dialog-preferencias.vala \
	nomeolvides-hecho.vala \
	nomeolvides-interfaz-principal.vala \
	nomeolvides-lista.vala \
	nomeolvides-liststore-anios.vala \
	nomeolvides-liststore-base.vala \
	nomeolvides-liststore-colecciones.vala \
	nomeolvides-liststore-hechos.vala \
	nomeolvides-liststore-listas.vala \
	nomeolvides-main.vala \
	nomeolvides-portada.vala \
	nomeolvides-preferencias-base.vala \
	nomeolvides-preferencias-colecciones.vala \
	nomeolvides-preferencias-listas.vala \
	nomeolvides-resources.c \
	nomeolvides-selector-fecha.vala \
	nomeolvides-sqlite.vala \
	nomeolvides-toolbar.vala \
	nomeolvides-treeview-anios.vala \
	nomeolvides-treeview-base.vala \
	nomeolvides-treeview-colecciones.vala \
	nomeolvides-treeview-hechos.vala \
	nomeolvides-utiles.vala \
	nomeolvides-ventana-principal.vala \
	$(NULL)



nomeolvides-resources.c: nomeolvides.gresource.xml
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) $(srcdir)/nomeolvides.gresource.xml \
	--target=$@ --sourcedir=$(srcdir) --c-name nomeolvides_git --generate-source

if DISABLE_GNOME3
nomeolvides_git_VALAFLAGS = \
	--pkg sqlite3 \
	--pkg gtk+-3.0 \
	-g \
	-D DISABLE_GNOME3
else
nomeolvides_git_VALAFLAGS = \
	--pkg sqlite3 \
	--pkg gtk+-3.0 \
	-g
endif

nomeolvides_git_LDFLAGS = \
	-Wl,--export-dynamic

nomeolvides_git_LDADD = $(NOMEOLVIDES_LIBS)


EXTRA_DIST = 	$(ui_DATA) \
		app-menu.ui

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

CLEANFILES = \
	$(vala_sources:.vala=.c)
clean-local:
	-rm *.c
