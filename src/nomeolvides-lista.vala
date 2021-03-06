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
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
using Nomeolvides;

public class Nomeolvides.Lista : Nomeolvides.Base {
	
	public Lista ( string nombre ) {
		base ( nombre );
	}

	public Lista.json ( string json ) {
		if (!json.contains ("{\"Lista\":{")) {
			json = "null";
		}	
		base.json ( "null" );
		
		this.hash = Utiles.calcular_checksum ( this.a_json () );
	}

	public new string a_json () {
		string retorno = "{\"Lista\":{";
		
		retorno += base.a_json ();
		retorno +="}}";	
		
		return retorno;
	}
}
