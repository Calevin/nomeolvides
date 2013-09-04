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
using GLib;
using Nomeolvides;

public class Nomeolvides.Datos : GLib.Object {

	//private Hechos hechos;
	public Deshacer deshacer;
    //public HechosColecciones colecciones;
	//public Listas listas;
	private AccionesDB db;

	public Datos () {

		this.deshacer = new Deshacer ();

		//this.hechos = new Hechos ();
		//this.colecciones = new HechosColecciones ();
		//this.listas = new Listas ();
		this.db = new AccionesDB ( Configuracion.base_de_datos() );

		this.conectar_signals ();
		
		this.cargar_colecciones_predefinidas ();
		this.cargar_datos_listas ();
	}

	private void conectar_signals () {
		//this.hechos.hechos_cambio_anios.connect ( this.signal_cambio_anios );
		//this.listas.listas_cambio_listas.connect ( this.signal_cambio_listas );
		//this.hechos.hechos_cambio_hechos.connect ( this.signal_cambio_hechos );
		//this.hechos.hechos_cambio_hechos_listas.connect ( this.signal_cambio_hechos_listas );

		this.deshacer.deshacer_sin_items.connect ( this.signal_no_hechos_deshacer );
		this.deshacer.deshacer_con_items.connect ( this.signal_hechos_deshacer );
		this.deshacer.rehacer_sin_items.connect ( this.signal_no_hechos_rehacer );
		this.deshacer.rehacer_con_items.connect ( this.signal_hechos_rehacer );
	}

	public void agregar_hecho (Hecho hecho) {
		this.db.insert_hecho ( hecho );
		this.datos_cambio_anios ();
		this.datos_cambio_hechos ();
	}

	public void agregar_hecho_lista ( Hecho hecho, Lista lista ) {
		this.db.insert_hecho_lista ( hecho, lista );
		this.datos_cambio_hechos ();
	}

	public void quitar_hecho_lista ( Hecho hecho, Lista lista ) {
		this.db.delete_hecho_lista ( hecho, lista );		
		this.datos_cambio_hechos ();
	}

	private void cargar_datos_listas () {
	/*	int1 i;
		string datos = Configuracion.cargar_listas_hechos ();
		string linea_lista_hash, linea_hecho_hash;

		var lineas = datos.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
			var linea = lineas[i].split (",");
			linea_lista_hash = linea[0];
			linea_hecho_hash = linea[1];
			this.hechos.agregar_hecho_lista ( linea_lista_hash, linea_hecho_hash );
		}
*/
	}

	public void eliminar_hecho ( Hecho hecho ) {
		this.deshacer.guardar_borrado ( hecho, DeshacerTipo.BORRAR );
		this.borrar_rehacer ();
		this.db.delete_hecho ( hecho );
		this.datos_cambio_anios ();
		this.datos_cambio_hechos ();
	}

	public void edit_hecho ( Hecho hecho ) {
			this.deshacer.guardar_borrado ( hecho, DeshacerTipo.EDITAR );
			this.deshacer.guardar_editado ( hecho );
			this.borrar_rehacer ();
			this.db.update_hecho ( hecho );
			this.datos_cambio_anios ();
			this.datos_cambio_hechos ();
	}

	public void deshacer_cambios () {
		DeshacerItem item;

		bool hay_hechos_deshacer = this.deshacer.deshacer ( out item ); 
		if ( hay_hechos_deshacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.eliminar_hecho ( item.get_editado() );
			}
			this.agregar_hecho ( item.get_borrado() );
			//this.guardar_un_archivo ( item.get_borrado().coleccion);
		}
	}

	public void rehacer_cambios () {
		DeshacerItem item;

		bool hay_hechos_rehacer = this.deshacer.rehacer ( out item ); 
		if ( hay_hechos_rehacer ){
			if ( item.get_tipo () == DeshacerTipo.EDITAR ) {
				this.eliminar_hecho ( item.get_editado() );
				this.agregar_hecho ( item.get_borrado() );
			} else {
				this.eliminar_hecho ( item.get_borrado() );
			}
			
			//this.guardar_un_archivo ( item.get_borrado().coleccion);
		}
	}


	public ArrayList<Hecho> lista_de_hechos () { 
		return (ArrayList<Hecho>) null; //this.hechos.lista_de_hechos ();
    }

	public Array<int> lista_de_anios ()
	{
		return this.db.lista_de_anios ();
	}

	public void cargar_colecciones_predefinidas ( ) {		
/*		int indice;
		ArrayList<string> locales = fuentes.lista_de_archivos ( FuentesTipo.LOCAL );
		ArrayList<string> http = fuentes.lista_de_archivos ( FuentesTipo.HTTP );

		this.hechos.vaciar ();

		for (indice = 0; indice < http.size; indice++ ) {
			this.open_file (http[indice], FuentesTipo.HTTP );
		}
		for (indice = 0; indice < locales.size; indice++ ) {
			this.open_file (locales[indice], FuentesTipo.LOCAL );
		}*/		
	}

	public void actualizar_colecciones_predefinidas ( ListStoreColecciones colecciones ) {
	/*	this.colecciones.actualizar_colecciones_liststore ( colecciones );
		this.cargar_colecciones_predefinidas ();
		this.cargar_datos_listas ();*/
	}

	public void actualizar_listas_personalizadas ( ListStoreListas listas ) {
		//this.listas.actualizar_listas_liststore ( listas );
		//this.cargar_datos_listas ();
	}

	public void save_file () {
	/*	int i;
		ArrayList<string> lista_archivos = this.colecciones.lista_de_archivos ( ColeccionTipo.LOCAL);
	
		for (i=0; i < lista_archivos.size; i++) {
			guardar_un_archivo ( lista_archivos[i] );
		}
	*/ 
	}

	public void guardar_un_archivo ( string archivo ) {
	/*	string a_guardar = "";
		ArrayList<Hecho> lista = this.lista_de_hechos ();
		int i;
		for (i=0; i < lista.size; i++) {
			if (lista[i].coleccion == archivo) {
				a_guardar +=lista[i].a_json() + "\n";
			}
		}
		Archivo.escribir ( archivo, a_guardar );	*/		
	}

	public void guardar_listas_hechos () {
/*	string a_guardar = "";
		var hash = this.hechos.get_hash_listas_hechos ();

		foreach ( string s in hash ) {
			a_guardar += s + "\n";
		}

		this.listas.guardar_listas_hechos ( a_guardar );*/
	}

	public void open_file ( string nombre_archivo ) {
		string todo;
		string[] lineas;
		Hecho nuevoHecho;
		int i;	

		todo = Archivo.leer ( nombre_archivo );

		lineas = todo.split_set ("\n");

		for (i=0; i < (lineas.length - 1); i++) {
        	nuevoHecho = new Hecho.json(lineas[i], nombre_archivo);
			if ( nuevoHecho.nombre != "null" ) {
				this.agregar_hecho(nuevoHecho);
			}
		}
	}

	public void save_as_file ( string archivo ) {
		/*string a_guardar = "";
		var array = this.hechos.lista_de_hechos ();
		
		foreach (Hecho h in array ) {
			a_guardar += h.a_json() + "\n"; 
		}

		Archivo.escribir ( archivo, a_guardar );*/
	}

	public void borrar_rehacer () {
		this.deshacer.borrar_rehacer ();
	}

	public ListStoreHechos get_liststore_anio ( int anio ) {
		var hechos = this.db.select_hechos ( "WHERE anio=\"" + anio.to_string () +"\"" );
		return this.armar_liststore_hechos(hechos);
	}

	public ListStoreHechos get_liststore_lista ( Lista lista ) {
		var lista_hechos = this.db.select_hechos_lista ( lista );
		return this.armar_liststore_hechos(lista_hechos);
	}

	public ListStoreListas lista_de_listas () {
		var listas = this.db.select_listas (); 
		
		return this.armar_liststore_listas ( listas );
	}

	public ListStoreColecciones lista_de_colecciones () {
		var colecciones = this.db.select_colecciones ();

		return this.armar_liststore_colecciones ( colecciones );
	}

	public bool hay_listas() {
		TreeIter iter;
		bool hay=false;

		var liststore = this.lista_de_listas();

		if ( liststore.get_iter_first ( out iter ) ) { 
			hay = true;
		}
		return hay;
	}

	public bool hay_colecciones_activas() {

		bool hay = false;
		var colecciones = this.db.select_colecciones ( "WHERE visible=\"true\"" );
		if ( colecciones.size > 0 ) {
			hay = true;
		}
		return hay;
	}

	private ListStoreHechos armar_liststore_hechos ( ArrayList<Hecho> hechos) {
		var liststore = new ListStoreHechos ();

		foreach ( Hecho h in hechos ) {
			liststore.agregar ( h );
		}

		return liststore;
	}

	private ListStoreListas armar_liststore_listas ( ArrayList<Lista> listas) {
		var liststore = new ListStoreListas ();

		foreach ( Lista l in listas ) {
			liststore.agregar_lista ( l );
		}

		return liststore;
	}

	private ListStoreColecciones armar_liststore_colecciones ( ArrayList<Coleccion> colecciones ) {
		var liststore = new ListStoreColecciones ();

		foreach ( Coleccion c in colecciones ) {
			liststore.agregar_coleccion ( c );
		}

		return liststore;
	}

	public void signal_cambio_anios () {
		this.datos_cambio_anios ();
	}

	public void signal_cambio_listas () {
		this.datos_cambio_listas ();
	}

	public void signal_cambio_hechos () {
		this.datos_cambio_hechos ();
	}

	public void signal_cambio_hechos_listas () {
		//this.listas.set_cantidad_hechos_listas( this.hechos.get_listas_size () );
		this.datos_cambio_hechos ();		
	}

	public void signal_hechos_deshacer () {
		this.datos_hechos_deshacer ();
	}

	public void signal_no_hechos_deshacer () {
		this.datos_no_hechos_deshacer ();
	}

	public void signal_hechos_rehacer () {
		this.datos_hechos_rehacer ();
	}

	public void signal_no_hechos_rehacer () {
		this.datos_no_hechos_rehacer ();
	}

	public signal void datos_cambio_anios ();
	public signal void datos_cambio_listas ();
	public signal void datos_cambio_hechos ();
	public signal void datos_hechos_deshacer ();
	public signal void datos_no_hechos_deshacer ();
	public signal void datos_hechos_rehacer ();
	public signal void datos_no_hechos_rehacer ();
}
