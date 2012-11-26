/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/* nomeolvides
 *
 * Copyright (C) 2012 Fernando Fernandez <fernando@softwareperonista.com.ar>
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

public class Nomeolvides.TextViewHecho : TextView {

	private Array<Hecho> hechos;

	public TextViewHecho ()
	{

		this.hechos = new Array<Hecho>();
		this.editable = false;
		this.cursor_visible = false;
	}

	public void mostrar ()
	{
		int i;
		string temp = "" ;
		
		for (i=0; i < this.hechos.length; i++) {

			temp += this.hechos.index(i).nombre + ": "
				 + this.hechos.index(i).descripcion + "\n";

		}
		this.buffer.text = temp;
	}

	public void agregarHecho (Hecho nuevo)
	{

		this.hechos.append_val(nuevo);
		this.mostrar();
	}

}
