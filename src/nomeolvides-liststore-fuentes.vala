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
using Gee;
using Nomeolvides;

public class Nomeolvides.ListStoreFuentes : ListStore {
	public ArrayList<string> archivos { get; private set; }
	private TreeIter iterador;
	
	public ListStoreFuentes () {
		Type[] tipos= { typeof(string), typeof(string), typeof(string), typeof(string), typeof(Fuente) };
		this.archivos = new ArrayList<string> ();
		this.set_column_types(tipos);
	}

	public void agregar_fuente ( Fuente fuente ) {		
		if (fuente.verificar_fuente () ) {		
			this.append ( out this.iterador );
			this.set ( this.iterador,
		                         0,fuente.nombre_fuente,
		                         1,fuente.nombre_archivo,
		                         2,fuente.direccion_fuente,
		                         3,traducir_tipo_fuente ( fuente.tipo_fuente ),
		                         4,fuente );
			this.archivos.add ( fuente.direccion_fuente + fuente.nombre_archivo );
		}	
	}

	private string traducir_tipo_fuente ( FuentesTipo tipo_fuente) {
		string tipo_traducido = "";
		
		switch ( tipo_fuente ){
			case FuentesTipo.LOCAL:
				tipo_traducido = "Local";
					break;							
		}
	
		return tipo_traducido;
	}
}
