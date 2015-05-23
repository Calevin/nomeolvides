/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
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

using Gtk;
using Nomeolvides;

public class Nomeolvides.DialogHecho : Dialog {
	protected Entry nombre_entry;
	protected TextView descripcion_textview;
	protected ScrolledWindow descripcion_scroll;
	protected ComboBox combo_colecciones;
	protected SelectorFecha fecha;
	protected Entry fuente_entry;
	public Hecho respuesta { get; protected set; }
	
	public DialogHecho (VentanaPrincipal ventana, ListStoreColecciones colecciones_liststore ) {
#if DISABLE_GNOME3
#else
		Object (use_header_bar: 1);
#endif
		this.resizable = true;
		this.modal = true;
		this.set_default_size (600,400);
		this.set_size_request (400,250);
		this.set_transient_for ( ventana as Window );

		this.add_button ( _("Cancel") , ResponseType.CANCEL);
		
		var nombre_label = new Label.with_mnemonic (_("Name") + ": ");
		var fecha_label = new Label.with_mnemonic (_("Date") + ": ");
		var coleccion_label = new Label.with_mnemonic (_("Colection") + ": ");
		var fuente_label = new Label.with_mnemonic (_("Source") + ": ");

		nombre_label.set_halign ( Align.END );
		fecha_label.set_halign ( Align.END );
		coleccion_label.set_halign ( Align.END );
		fuente_label.set_halign ( Align.END );
#if DISABLE_GNOME3
		nombre_label.set_margin_left ( 15 );
		fecha_label.set_margin_left ( 15 );
		coleccion_label.set_margin_left ( 15 );
		fuente_label.set_margin_left ( 15 );
#else
		nombre_label.set_margin_end ( 15 );
		fecha_label.set_margin_end ( 15 );
		coleccion_label.set_margin_end ( 15 );
		fuente_label.set_margin_end ( 15 );
#endif
		this.nombre_entry = new Entry ();
		this.fuente_entry = new Entry ();
		
		this.combo_colecciones = new ComboBox ();
		this.fecha = new SelectorFecha ();

		var descripcion_frame = new Frame( _("Description") );
		descripcion_frame.set_shadow_type(ShadowType.ETCHED_IN);
		this.descripcion_scroll = new ScrolledWindow ( null, null );
		this.descripcion_scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
		this.descripcion_textview = new TextView ();
		this.descripcion_textview.set_wrap_mode (WrapMode.WORD);
		
		this.descripcion_scroll.add( this.descripcion_textview );
		descripcion_frame.add ( this.descripcion_scroll );
		descripcion_frame.set_hexpand ( true );
		descripcion_frame.set_vexpand ( true );

		this.set_combo_box ( colecciones_liststore );

		var grid = new Grid ();

		grid.attach ( nombre_label, 0, 0, 1, 1 );
		grid.attach ( nombre_entry, 1, 0, 1, 1 );
		grid.attach ( fecha_label, 0, 1, 1, 1 );
		grid.attach ( fecha, 1, 1, 1, 1 );
		grid.attach ( coleccion_label, 0, 2, 1, 1 );
		grid.attach ( combo_colecciones, 1, 2, 1, 1 );
		grid.attach ( fuente_label, 0, 3, 1, 1 );
		grid.attach ( fuente_entry, 1, 3, 1, 1 );
		grid.attach ( descripcion_frame, 0, 4, 2, 1 );
		grid.set_row_spacing ( 5 );
		grid.set_border_width ( 4 );
		
		var contenido = this.get_content_area() as Box;

		contenido.pack_start( grid, true, true, 0 );
		
		this.show_all ();
	}

	protected void crear_respuesta() {
		if(this.nombre_entry.get_text_length () > 0) {
			this.respuesta  = new Hecho ( Utiles.sacarCaracterEspecial ( this.nombre_entry.get_text () ),
										  Utiles.sacarCaracterEspecial ( this.descripcion_textview.buffer.text ),
										  this.fecha.get_anio (),
										  this.fecha.get_mes (),
										  this.fecha.get_dia (),
										  this.get_coleccion (),
										  Utiles.sacarCaracterEspecial ( this.fuente_entry.get_text () ) );
		}
	}

	protected void set_combo_box ( ListStoreColecciones liststore) {
		CellRendererText renderer = new CellRendererText ();
		this.combo_colecciones.pack_start (renderer, true);
		this.combo_colecciones.add_attribute (renderer, "text", 0);
		this.combo_colecciones.active = 0;
		this.combo_colecciones.set_model ( liststore );
	}

	protected int64 get_coleccion () {
		TreeIter iter;
		Value value_coleccion;
		Coleccion coleccion;

		this.combo_colecciones.get_active_iter( out iter );
		ListStoreColecciones liststore = this.combo_colecciones.get_model () as ListStoreColecciones;
		liststore.get_value ( iter, 2, out value_coleccion );
		coleccion = value_coleccion as Coleccion;
		
		return coleccion.id;
	}
}
