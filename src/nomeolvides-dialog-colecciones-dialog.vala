/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2013 Andres Fernandez <andres@softwareperonista.com.ar>
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
 *   bullit - 39 escalones - silent love (japonesa) 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.ColeccionesDialog : Gtk.Dialog {
	public TreeViewColecciones colecciones_view { get; private set; }
	private ToolButton aniadir_coleccion_button;
	private ToolButton editar_coleccion_button;
	private ToolButton borrar_coleccion_button;
	public bool cambios { get; private set; }
	public Button boton_aniadir;
	private AccionesDB db;
		
	public ColeccionesDialog (VentanaPrincipal ventana, ListStoreColecciones liststore_colecciones) {
		this.set_title ("Colecciones de hechos históricos");
		this.set_modal ( true );
		this.set_default_size (500, 350);
		this.set_transient_for ( ventana as Gtk.Window );

		Toolbar toolbar = new Toolbar ();
		this.aniadir_coleccion_button = new ToolButton.from_stock ( Stock.ADD );
		this.editar_coleccion_button = new ToolButton.from_stock ( Stock.EDIT );
		this.borrar_coleccion_button = new ToolButton.from_stock ( Stock.DELETE );
		aniadir_coleccion_button.is_important = true;
		editar_coleccion_button.is_important = true;
		borrar_coleccion_button.is_important = true;
		editar_coleccion_button.set_visible_horizontal ( false );
		borrar_coleccion_button.set_visible_horizontal ( false );
		SeparatorToolItem separador = new SeparatorToolItem ();
		separador.set_expand ( true );
		separador.draw = false;
		this.db = new AccionesDB ( Configuracion.base_de_datos() );

		editar_coleccion_button.clicked.connect ( edit_coleccion_dialog );
		borrar_coleccion_button.clicked.connect ( borrar_coleccion_dialog );
		aniadir_coleccion_button.clicked.connect ( add_coleccion_dialog );

		toolbar.add ( aniadir_coleccion_button );
		toolbar.add ( separador );
		toolbar.add ( editar_coleccion_button );
		toolbar.add ( borrar_coleccion_button );
		
		this.add_button ( Stock.CLOSE, ResponseType.CLOSE );
		this.response.connect(on_response);

		this.cambios = false;
		this.colecciones_view = new TreeViewColecciones ();
		this.colecciones_view.set_model ( liststore_colecciones );
		this.colecciones_view.cursor_changed.connect ( elegir_coleccion );
		this.colecciones_view.coleccion_visible_toggle_change.connect ( signal_toggle_change );

		var scroll_colecciones_view = new ScrolledWindow (null,null);
		scroll_colecciones_view.set_policy (PolicyType.NEVER, PolicyType.AUTOMATIC);
		scroll_colecciones_view.add ( this.colecciones_view );
 
		Gtk.Box contenido =  this.get_content_area () as Box;
		contenido.add ( toolbar );
		contenido.pack_start ( scroll_colecciones_view, true, true, 0 );
	}

	private void on_response (Dialog source, int response_id)
	{
		this.destroy ();
    }

	private void add_coleccion_dialog () {
		ListStoreColecciones liststore;
		Coleccion coleccion;
		
		var add_dialog = new AddColeccionDialog ( );
		add_dialog.show_all ();

		if (add_dialog.run() == ResponseType.APPLY) {
			coleccion = add_dialog.respuesta;
			this.db.insert_coleccion ( coleccion );
			coleccion.id = this.db.ultimo_rowid();
			liststore = this.colecciones_view.get_model () as ListStoreColecciones;
			liststore.agregar_coleccion (coleccion);
			this.cambios = true;
		}
		
		add_dialog.destroy ();
	}

	private void edit_coleccion_dialog () {
		ListStoreColecciones liststore;

		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" + this.colecciones_view.get_coleccion_cursor ().to_string() + "\"");
		var edit_dialog = new EditColeccionDialog ();
		edit_dialog.set_datos ( coleccion );
		edit_dialog.show_all ();

		if (edit_dialog.run() == ResponseType.APPLY) {
			liststore = this.colecciones_view.get_model () as ListStoreColecciones;
			this.colecciones_view.eliminar_coleccion ( coleccion );
			liststore.agregar_coleccion ( edit_dialog.respuesta );
			this.db.update_coleccion ( edit_dialog.respuesta );
			this.cambios = true;
		}
		
		edit_dialog.destroy ();
	}

	private void borrar_coleccion_dialog () {
		Coleccion coleccion = this.db.select_coleccion ( "WHERE rowid=\"" + this.colecciones_view.get_coleccion_cursor ().to_string() + "\"");
		var borrar_dialog = new BorrarColeccionDialogo ( coleccion );
		borrar_dialog.show_all ();

		if (borrar_dialog.run() == ResponseType.APPLY) {
			this.colecciones_view.eliminar_coleccion ( coleccion );
		}
		borrar_dialog.destroy ();

		this.cambios = true;
	}

	private void set_buttons_visible ( bool cambiar ) {
		this.editar_coleccion_button.set_visible_horizontal ( cambiar );
		this.borrar_coleccion_button.set_visible_horizontal ( cambiar );
	}

	private void elegir_coleccion () {
		if(this.colecciones_view.get_coleccion_cursor () >-1) {
			this.set_buttons_visible ( true );
		} else {
			this.set_buttons_visible ( false );		
		}
	}

	private void signal_toggle_change () {
		this.cambios = true;
	}
}
