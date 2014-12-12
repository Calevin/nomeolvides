/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* Nomeolvides
 * 
 * Copyright (C) 2012 Andres Fernandez <andres@softwareperonista.com.ar>
 * 
 * nomeolvides is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * nomeolvides is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;
using Nomeolvides;

public class Nomeolvides.App : Gtk.Application  {
	public static App app;
	public VentanaPrincipal window;
	public Datos datos;
	public GLib.Menu application_menu;
	private Migrador migrador;
	private DialogPreferencias dialogo_preferencias;

	private void create_window () {
		this.window = new VentanaPrincipal (this);

		this.create_app_menu ( );
		this.connect_signals ();

		this.window.show_visible ();
		this.inicializar_ventana ();
	}

	public void inicializar_ventana () {
		this.cargar_lista_anios ();
		this.cargar_listas ();
		this.cargar_lista_hechos ();
	}

	public override void activate () {
		create_window();
		if (Configuracion.hay_colecciones ()  || Configuracion.hay_listas () ) {
			this.migrador = new Migrador( this.window );
			this.migrador.hay_migrados_signal.connect (	this.inicializar_ventana );
		}
		this.preferencias ();
	}

	public void create_app_menu () {
	#if DISABLE_GNOME3
	#else
		var action = new GLib.SimpleAction ("salir-app", null);
		action.activate.connect (() => { salir_app (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("about", null);
		action.activate.connect (() => { about_dialog (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("importar-hechos", null);
		action.activate.connect (() => { importar (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("exportar-hechos", null);
		action.activate.connect (() => { exportar (); });
		this.add_action (action);

		action = new GLib.SimpleAction ("preferencias-dialog", null);
		action.activate.connect (() => { preferencias_dialog ( false ); });
		this.add_action (action);

		var builder = new Builder ();
	    try {
		    builder.add_from_resource ( "/org/softwareperonista/nomeolvides-git/nomeolvides-app-menu.ui");
  			set_app_menu ((MenuModel)builder.get_object ("app-menu"));
		} catch (GLib.Error e ) {
    		error ("loading ui file: %s", e.message); 
		}
	#endif
	}

	private void connect_signals () {
		this.window.toolbar_add_button_clicked.connect ( this.add_hecho_dialog );
		this.window.toolbar_undo_button_clicked.connect ( this.undo_hecho );
		this.window.toolbar_redo_button_clicked.connect ( this.redo_hecho );
		this.window.toolbar_edit_button_clicked.connect ( this.edit_hecho_dialog );
		this.window.toolbar_delete_button_clicked.connect ( this.delete_hecho_dialog );
		this.window.toolbar_send_button_clicked.connect ( this.send_hecho );
		this.window.toolbar_list_agregar_button_clicked.connect ( this.add_hecho_lista );
		this.window.toolbar_list_quitar_button_clicked.connect ( this.remove_hecho_lista );

		this.window.anios_hechos_anios_cursor_changed.connect ( this.elegir_anio );
		this.window.anios_hechos_listas_cursor_changed.connect ( this.elegir_lista );
		
		this.datos.datos_cambio_anios.connect ( this.cargar_lista_anios );
		this.datos.datos_cambio_listas.connect ( this.cargar_listas );
		this.datos.datos_cambio_hechos.connect ( this.cargar_lista_hechos );
		this.datos.datos_hechos_deshacer.connect ( this.window.activar_boton_deshacer );
		this.datos.datos_no_hechos_deshacer.connect ( this.window.desactivar_boton_deshacer  );
		this.datos.datos_hechos_rehacer.connect ( this.window.activar_boton_rehacer );
		this.datos.datos_no_hechos_rehacer.connect ( this.window.desactivar_boton_rehacer  );
	#if DISABLE_GNOME3
		this.window.menu_importar_activate.connect ( this.importar );
		this.window.menu_exportar_activate.connect ( this.exportar );
		this.window.menu_salir_activate.connect ( this.salir_app );
		this.window.menu_preferencias_activate.connect ( this.preferencias_dialog_run );
		this.window.menu_acerca_activate.connect ( this.about_dialog );
	#endif
	}

	public void add_hecho_dialog () {

		if ( !(this.datos.hay_colecciones_activas ()) ) {
				this.preferencias_dialog ( false );
		}

		if ( this.datos.hay_colecciones_activas () ) {

			var add_dialog = new DialogHechoAgregar ( this.window as VentanaPrincipal,
													this.datos.lista_de_colecciones () );

			add_dialog.show();

			if ( add_dialog.run() == ResponseType.APPLY ) {
				this.datos.agregar_hecho( add_dialog.respuesta );
			}
			add_dialog.destroy();
			this.window.toolbar.add_button.set_active ( false );
		}
	}
	
	private void elegir_anio () {
		int anio = this.window.get_anio_actual ();
		this.window.cargar_hechos_view ( this.datos.get_hechos_anio ( anio ) );
	}

	private void elegir_lista () {
		Lista lista = this.window.get_lista_actual ();
		this.window.cargar_hechos_view ( this.datos.get_hechos_lista ( lista ));
	}

	public void edit_hecho_dialog () {
		Hecho hecho; 

		this.window.get_hecho_actual ( out hecho );

		var edit_dialog = new DialogHechoEditar( this.window, this.datos.lista_de_colecciones () );
		edit_dialog.set_datos ( hecho );
		edit_dialog.show_all ();

		if ( edit_dialog.run() == ResponseType.APPLY ) {
			this.datos.edit_hecho ( edit_dialog.respuesta );
		}
		edit_dialog.destroy();
		this.window.toolbar.edit_button.set_active ( false );
	}

	public void delete_hecho_dialog () {
		DialogHechoBorrar delete_dialog = new DialogHechoBorrar ( this.window as VentanaPrincipal);
		delete_dialog.setear_hechos ( this.window.get_hechos_seleccionados () );

		if (delete_dialog.run() == ResponseType.APPLY) {
			for (int i = 0; i < delete_dialog.hechos.length; i++ ) {
				this.datos.eliminar_hecho ( delete_dialog.hechos.index (i) );
			}
		}	
		delete_dialog.destroy ();
		this.window.toolbar.delete_button.set_active ( false );
	}

	public void about_dialog () {
		Configuracion.create_about_dialog ( this.window );
	}

	private void salir_app () {
		this.window.destroy ();
	}

	private void preferencias_dialog ( bool ver_listas=false ) {
		if ( ver_listas ) {
			this.dialogo_preferencias.set_active_listas ();
		}
		this.preferencias_dialog_run ();
	}

	private void preferencias_dialog_run () {
		this.dialogo_preferencias.ejecutar ( this.datos.lista_de_colecciones (), this.datos.lista_de_listas () );
		this.dialogo_preferencias.show_all ();
		this.dialogo_preferencias.set_toolbar_buttons_invisible ();
		this.dialogo_preferencias.run ();
	}

	private void preferencias ( ) {
		var colecciones = this.datos.lista_de_colecciones ();
		var listas = this.datos.lista_de_listas ();
		this.dialogo_preferencias = new DialogPreferencias ( this.window, colecciones, listas );
		this.dialogo_preferencias.hide.connect ( this.inicializar_ventana );
		this.dialogo_preferencias.hide ();
	}

	public void send_hecho () {
		Hecho hecho; 
		string asunto;
		string cuerpo;
		string direccion;
		string archivo;

		this.window.get_hecho_actual ( out hecho );

		if( hecho != null) {
			string hechos_json = "";
			asunto = "Envío un hecho para contribuir con la base de datos oficial";
			cuerpo = "Estimados, quisiera contribuir con este hecho a mejorar la base de datos oficial de Nomeolvides.";
			direccion = "fernando@softwareperonista.com.ar, andres@softwareperonista.com.ar";
			archivo = GLib.Environment.get_tmp_dir () + "/"+ Utiles.nombre_para_archivo ( "hechos-de-nomeolvides" ) +".json";

			var hechos = this.window.get_hechos_seleccionados ();
			for ( int i = 0; i < hechos.length; i++ ) {
				hechos_json += hechos.index (i).a_json () + "\n";
			}
			Archivo.escribir (archivo, hechos_json );
		
			string commando = @"xdg-email --subject '$asunto' --body '$cuerpo' --attach '$archivo' $direccion";
			try {
				Process.spawn_command_line_async( commando );
			} catch(SpawnError err) {
				stdout.printf(err.message+"\n");
			}
		}
		this.window.toolbar.send_button.set_active ( false );
	}

	public void undo_hecho () {
		this.datos.deshacer_cambios ();
		this.window.toolbar.undo_button.set_active ( false );
	}

	public void redo_hecho () {
		this.datos.rehacer_cambios ();
		this.window.toolbar.redo_button.set_active ( false );
	}

	public void add_hecho_lista () {
		Hecho hecho;
		this.window.get_hecho_actual ( out hecho );

		if ( !( this.datos.hay_listas ()) ) {
			this.preferencias_dialog ( true );
		}

		if ( this.datos.hay_listas () ) {
			DialogHechoListaAgregar dialogo = new DialogHechoListaAgregar ( this.window );

			dialogo.setear_hechos ( this.window.get_hechos_seleccionados () );
			dialogo.setear_listas ( this.datos.lista_de_listas() );

			if (dialogo.run () == ResponseType.APPLY) {
				for (int i = 0; i < dialogo.hechos.length; i++ ) {
					this.datos.agregar_hecho_lista ( dialogo.hechos.index (i), dialogo.get_id_lista () );
				}
			}
			dialogo.close ();
		}
		this.window.toolbar.list_button.active = false;
		this.window.toolbar.list_button.set_active ( false );
	}

	public void remove_hecho_lista () {
		var dialogo = new DialogHechoListaBorrar ( this.window );
		var lista = this.window.get_lista_actual ();

		dialogo.set_hechos ( this.window.get_hechos_seleccionados () );
		dialogo.set_lista ( lista );

		if (dialogo.run () == ResponseType.APPLY) {
			for ( int i = 0; i < dialogo.hechos.length; i++ ) {
				this.datos.quitar_hecho_lista ( dialogo.hechos.index (i), lista );
			}
		}
		dialogo.close ();
		this.window.toolbar.list_button.set_active ( false );

	}

	public void save_as_file_dialog () {
		DialogArchivoGuardar guardar_archivo = new DialogArchivoGuardar ( GLib.Environment.get_current_dir () );
		guardar_archivo.set_transient_for ( this.window );

		if (guardar_archivo.run () == ResponseType.ACCEPT) {		
			this.datos.save_as_file ( guardar_archivo.get_filename () );
		}
		guardar_archivo.close ();
	}

	public void importar_dialog () {
		var abrir_archivo = new DialogHechosImportar (this.window, GLib.Environment.get_current_dir (), this.datos.lista_de_colecciones ());
		abrir_archivo.set_transient_for ( this.window );

		if (abrir_archivo.run () == ResponseType.ACCEPT) {
			this.datos.open_file ( abrir_archivo.get_filename (), abrir_archivo.get_coleccion_id () );
		}
		abrir_archivo.close ();
	}

	private void exportar () {
		this.save_as_file_dialog ();
	}

	private void importar () {
		this.importar_dialog ();
	}

	public void cargar_listas () {
		this.window.cargar_listas_view ( this.datos.lista_de_listas () );
	}

	public void cargar_lista_anios () {
		this.window.cargar_anios_view ( this.datos.lista_de_anios () );
	}

	public void cargar_lista_hechos () {
		var pestania = this.window.get_pestania ();

		if ( pestania == _("Years") ) {
			this.elegir_anio ();
		} else {
			this.elegir_lista ();
		}
	}

	public App () {
		app = this;
		Configuracion.set_config ();
		this.datos = new Datos ();
	}
}
