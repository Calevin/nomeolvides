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
using Gee;

public class Nomeolvides.HechosFuentes : GLib.Object {
	public ListStoreFuentes fuentes_liststore { get; private set; }
		
	public HechosFuentes () {
		this.fuentes_liststore = new ListStoreFuentes ();		
		this.cargar_fuentes ();
	}

	public void actualizar_fuentes_liststore ( ListStoreFuentes nueva_fuentes_liststore) {
		this.fuentes_liststore = nueva_fuentes_liststore;
		this.guardar_fuentes ();
	}

	private void guardar_fuentes () {
		string guardar = this.fuentes_liststore.a_json ();
		
		Configuracion.guardar_fuentes ( guardar );
	}

	private void cargar_fuentes () {
		string todo;
		string[] lineas;
		Fuente nueva_fuente;
		int i;	

		var fuente_oficial = new Fuente ( "Base de datos oficial" , "base_de_datos.json", "https://dl.dropbox.com/u/14325890/nomeolvides/", true, FuentesTipo.HTTP );
		this.fuentes_liststore.agregar_fuente ( fuente_oficial );

		todo = Configuracion.cargar_fuentes ();
		
		lineas = todo.split_set ("\n");
		for (i=0; i < lineas.length; i++) {
        	nueva_fuente = new Fuente.json(lineas[i]);
			if ( nueva_fuente.nombre_fuente != "null" ) {
				this.fuentes_liststore.agregar_fuente ( nueva_fuente );
			}
		}
	}

	public ListStoreFuentes temp () {
		GLib.Value fuente_value;
		Fuente fuente;
		ListStoreFuentes temp = new ListStoreFuentes ();
		TreeIter iterador;
		
		this.fuentes_liststore.get_iter_first ( out iterador );
		
		do {
			this.fuentes_liststore.get_value (iterador, 5, out fuente_value);
			fuente = fuente_value as Fuente;
			temp.agregar_fuente( fuente );
		}while ( this.fuentes_liststore.iter_next ( ref iterador) );
		        
		return temp;
	}

	public ListStoreFuentes get_fuentes_locales () {
		GLib.Value fuente_value;
		Fuente fuente;
		ListStoreFuentes temp = new ListStoreFuentes ();
		TreeIter iterador;
		
		this.fuentes_liststore.get_iter_first ( out iterador );
		
		do {
			this.fuentes_liststore.get_value (iterador, 4, out fuente_value);
			fuente = fuente_value as Fuente;
			if( fuente.tipo_fuente == FuentesTipo.LOCAL ) {
				temp.agregar_fuente( fuente );
			}	
		}while ( this.fuentes_liststore.iter_next ( ref iterador) );
		        
		return temp;
	}
	
	public ArrayList<string> lista_de_archivos (FuentesTipo tipo) { 
		TreeIter iter;
		Value value_fuente;
		Fuente fuente;
		ArrayList<string> retorno = new ArrayList<string> ();

		this.fuentes_liststore.get_iter_first(out iter);
		do {
			this.fuentes_liststore.get_value(iter, 5, out value_fuente);
			fuente = value_fuente as Fuente;
			if (fuente.tipo_fuente == tipo) {
				retorno.add ( fuente.direccion_fuente + fuente.nombre_archivo );
			}
		}while (this.fuentes_liststore.iter_next(ref iter));

		return retorno;
	}
}
