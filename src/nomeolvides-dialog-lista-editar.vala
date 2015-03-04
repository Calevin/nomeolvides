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

public class Nomeolvides.DialogListaEditar : DialogBase {
#if DISABLE_GNOME3
	public DialogListaEditar () {
		this.title = _("Edit Custom List");
		Button boton_apply = this.get_widget_for_response ( ResponseType.APPLY ) as Button;
		boton_apply.set_label ( _("Edit") );
#else
	public Base objeto_viejo;
	public DialogListaEditar ( Widget relative_to ) {
		base ( relative_to );
		base.aplicar_button.set_label ( _("Edit") );
#endif
		this.nombre_label.set_label (_("List Name") + ": ");
	}
#if DISABLE_GNOME3
	protected override void crear_respuesta () {
		if(this.nombre_entry.get_text_length () > 0) {
			this.respuesta  = new Lista (this.nombre_entry.get_text ());
			this.respuesta.id = this.id;
		}
	}
#else
	protected override void aplicar () {
		if ( this.nombre_entry.get_text_length () > 0 ) {
			this.respuesta = new Lista ( this.nombre_entry.get_text () );
			this.respuesta.id = this.id;
			this.signal_actualizar( this.objeto_viejo, this.respuesta );
			this.borrar_datos ();
			this.ocultar ();
		}
	}

	public override void set_datos ( Base objeto ) {
		base.set_datos ( objeto );
		this.objeto_viejo = objeto;
	}
#endif
}

