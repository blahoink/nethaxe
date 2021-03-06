package oink.nethaxe;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import pgr.dconsole.DC;

import oink.nethaxe.client.Client;
import oink.nethaxe.server.Server;

class Net {

	public static inline var DEFAULT_HOSTNAME:String = '127.0.0.1';
	public static inline var DEFAULT_PORT:Int = 3000;
	
	public static var inited:Bool = false;
	
	public static var server:Dynamic;
	public static var client:Dynamic;
	
	public static var server_class:Class<Server>;
	public static var client_class:Class<Client>;
	
	public static var server_class_args:Array<Dynamic>;
	public static var client_class_args:Array<Dynamic>;
	
	public static var server_active:Bool;
	public static var client_active:Bool;
	
	/**
	 * set flags and defaults. nothing fancy
	 * forced to run before anything is done with Net
	 */
	public static function init():Void {
		
		// set defaults
		server_class = Server;
		client_class = Client;
		
		server_class_args = [];
		client_class_args = [];
		
		server_active = false;
		client_active = false;
		
		inited = true;
	}
	
	/**
	 * create server instance.
	 * set a specified instance with extend_server
	 */
	public static function create_server():Void {
		if (!inited) init();
		server = Type.createInstance(server_class, server_class_args);
	}
	/**
	 * create client instance
	 * set a specified instance with extend_client
	 */
	public static function create_client():Void {
		if (!inited) init();
		client = Type.createInstance(client_class, client_class_args);
	}
	
	/**
	 * helper function to verify arguments of bson packets before processing
	 * @param	Packet BSON packet to check
	 * @param	Fields Array of fields to check
	 * @return Array of fields that exist in Packet
	 */
	public static function verify_fields(Packet:Dynamic, Fields:Array<String>):Array<String> {
		if (Packet == null) return null;
		if (Fields.length <= 0) return null;
		
		var out:Array<String> = [];
		
		for (field in Fields) {
			if (Reflect.hasField(Packet, field)) out.push(field);
		}
		
		return out;
	}	
	
	/**
	 * kill la kill
	 */
	public static function destroy():Void {
		if (!inited) return;
		
		// kill client and server if they exist
		if(server != null)
			server.destroy();
		if(client != null)
			client.destroy();
	}
}
