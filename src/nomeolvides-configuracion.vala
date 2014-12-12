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

using Gtk;
using Nomeolvides;

public class Nomeolvides.Configuracion : GLib.Object {
	public static void create_about_dialog ( VentanaPrincipal window ) {
		string[] authors = {
  			"Andres Fernandez <andres@softwareperonista.com.ar>",
  			"Fernando Fernandez <fernando@softwareperonista.com.ar>"
		};
		Gtk.show_about_dialog (window,
			   "authors", authors,
			   "program-name", "Nomeolvides Git",
			   "title", _("About Nomeolvides"),
			   "comments", _("Historical ephemeris manager"),
			   "copyright", "Copyright 2012, 2013, 2014 Fernando Fernandez " + _("and") + " Andres Fernandez",
			   "license-type", Gtk.License.GPL_3_0,
			   "logo-icon-name", "nomeolvides-git",
			   "version", Config.VERSION,
			   "website", "https://github.com/softwareperonista/nomeolvides",
			   "wrap-license", true);	
	}
	
	public static void set_config () {		
		if ( !Archivo.existe_path ( Configuracion.directorio_datos () ) ) {
			Archivo.crear_directorio ( Configuracion.directorio_datos () );
		}

		if (!Archivo.existe_path ( Configuracion.base_de_datos () ) ) {
			string stdout;
			string stderr;
			int exitstatus;

			try {
				Process.spawn_command_line_sync ( "sqlite3 " +   Configuracion.base_de_datos () + " \"" +  Configuracion.db_sql () + "\"", out stdout, out stderr, out exitstatus);
			} catch (SpawnError e) {
				print ("Error: %s\n", e.message);
				print ("Comando:\n" + "sqlite3 " +   Configuracion.base_de_datos () + " \"" +  Configuracion.db_sql () + "\"\n\n");
				print ("Salida:\n\tstdout : " + stdout + "\n\tstderr : " + stderr + "\n\texitstatus : " + exitstatus.to_string () + "\n");
			}
		}
	}	

	public static void guardar_colecciones ( string colecciones ) {
		Archivo.escribir ( Configuracion.archivo_colecciones (), colecciones );
	}

	public static string cargar_colecciones () {
		return Archivo.leer ( Configuracion.archivo_colecciones () );
	}

	public static void guardar_listas ( string listas ) {
		Archivo.escribir ( Configuracion.archivo_listas (), listas );
	}

	public static string cargar_listas () {
		return Archivo.leer ( Configuracion.archivo_listas () );
	}

	public static string cargar_listas_hechos () {
		return Archivo.leer ( Configuracion.archivo_listas_hechos () );
	}

	public static void guardar_listas_hechos ( string listas_hechos ) {
		Archivo.escribir ( Configuracion.archivo_listas_hechos (), listas_hechos );
	}

	public static bool hay_colecciones () {
		return Archivo.existe_path ( Configuracion.archivo_colecciones () );
	}

	public static bool hay_listas () {
		return Archivo.existe_path ( Configuracion.archivo_listas () );
	}

	private static string directorio_datos () {
		return GLib.Environment.get_home_dir () + "/.local/share/nomeolvides-git";
	}

	public static string base_de_datos () {
		return Configuracion.directorio_datos () + "/nomeolvides-git.db";
	}

	public static string archivo_colecciones () {
		return Configuracion.directorio_configuracion () + "/db-predeterminadas.json";
	}

	public static string archivo_listas () {
		return Configuracion.directorio_configuracion () + "/listas-personalizadas.json";
	}

	private static string directorio_configuracion () {
		return GLib.Environment.get_user_config_dir () + "/nomeolvides-git";
	}

	private static string archivo_listas_hechos () {
		return Configuracion.directorio_datos () + "/listas";
	}

	private static string db_sql () {
	return "PRAGMA foreign_keys=OFF;
				BEGIN TRANSACTION;
				CREATE TABLE colecciones (
					id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					nombre TEXT NOT NULL UNIQUE,
					visible BOOLEAN NOT NULL
				);
				CREATE TABLE hechos (
					id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					nombre TEXT NOT NULL,
					descripcion TEXT,
					anio INTEGER NOT NULL,
					mes INTEGER NOT NULL,
					dia INTEGER NOT NULL,
					fuente TEXT,
					coleccion INTEGER NOT NULL,
					FOREIGN KEY (coleccion) REFERENCES colecciones (id) ON DELETE CASCADE
				 );
				CREATE TABLE listas (
					id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
					nombre TEXT NOT NULL UNIQUE
				);
				CREATE TABLE hechosborrar (
					id INTEGER NOT NULL PRIMARY KEY
				);
				CREATE TABLE coleccionesborrar (
					id INTEGER NOT NULL PRIMARY KEY
				);
				CREATE TABLE listasborrar (
					id INTEGER NOT NULL PRIMARY KEY
				);
				CREATE TABLE listashechos (
					lista INTEGER NOT NULL,
					hecho INTEGER NOT NULL,
					PRIMARY KEY (lista,hecho),
					FOREIGN KEY (lista) REFERENCES listas (id) ON DELETE CASCADE,
					FOREIGN KEY (hecho) REFERENCES hechos (id) ON DELETE CASCADE
				);
				CREATE UNIQUE INDEX indice_hechos ON hechos (nombre,anio,mes,dia);
				INSERT INTO hechosborrar VALUES (0);
				COMMIT;";
	}
}
