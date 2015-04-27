/**
 *
 * Copyright (c) 2014, the Railo Company Ltd. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either 
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 **/
package lucee.runtime.gateway;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map.Entry;

import lucee.commons.lang.ClassException;
import lucee.commons.lang.ClassUtil;
import lucee.commons.lang.StringUtil;
import lucee.runtime.config.Config;
import lucee.runtime.exp.ApplicationException;
import lucee.runtime.exp.PageException;
import lucee.runtime.gateway.proxy.GatewayProFactory;
import lucee.runtime.op.Caster;
import lucee.runtime.op.Duplicator;
import lucee.runtime.type.Collection.Key;
import lucee.runtime.type.Struct;

public class GatewayEntryImpl implements GatewayEntry {

	private String id;
	private Struct custom;
	private boolean readOnly;
	private String listenerCfcPath;
	private int startupMode;
	private GatewayPro gateway;
	private String cfcPath;
	private String className;
	private GatewayEnginePro engine;

	public GatewayEntryImpl(GatewayEnginePro engine,String id, String className, String cfcPath, String listenerCfcPath, String startupMode,Struct custom, boolean readOnly) {
		this.engine=engine;
		this.id=id;
		this.listenerCfcPath=listenerCfcPath;
		this.className=className;
		this.custom=custom;
		this.readOnly=readOnly;
		this.cfcPath=cfcPath;
		startupMode=startupMode.trim().toLowerCase();
		if("manual".equals(startupMode))this.startupMode=STARTUP_MODE_MANUAL;
		else if("disabled".equals(startupMode))this.startupMode=STARTUP_MODE_DISABLED;
		else this.startupMode=STARTUP_MODE_AUTOMATIC;
	}
	

	/**
	 * @return the gateway
	 * @throws ClassException 
	 * @throws PageException 
	 */
	public void createGateway(Config config) throws ClassException, PageException {
		if(gateway==null){
			if(!StringUtil.isEmpty(className)){
				Class clazz = ClassUtil.loadClass(config.getClassLoader(),className);
				
				gateway=GatewayProFactory.toGatewayPro(ClassUtil.loadInstance(clazz));
			}
			else if(!StringUtil.isEmpty(cfcPath)){
				gateway=new CFCGateway(cfcPath);
			}
			else throw new ApplicationException("missing gateway source definitions");
			try{
				//new GatewayThread(engine,gateway,GatewayThread.START).run();
				gateway.init(engine,getId(), getListenerCfcPath(),getCustom());
				if(getStartupMode()==GatewayEntry.STARTUP_MODE_AUTOMATIC){
					new GatewayThread(engine,gateway,GatewayThread.START).start();
					/*try{
						//gateway.doStart();
					}
					catch(GatewayException ge){
						engine.log(gateway,GatewayEngine.LOGLEVEL_ERROR, ge.getMessage());
					}*/
				}
			}
			catch(IOException ioe){
				throw Caster.toPageException(ioe);
			}
		}
	}
	
	@Override
	public GatewayPro getGateway() {
		return gateway;
	}
	
	@Override
	public String getId() {
		return id;
	}

	@Override
	public Struct getCustom() {
		return (Struct) Duplicator.duplicate(custom,true);
	}

	@Override
	public boolean isReadOnly() {
		return readOnly;
	}
	

	/**
	 * @return the cfcPath
	 */
	public String getListenerCfcPath() {
		return listenerCfcPath;
	}
	
	@Override
	public String getCfcPath() {
		return cfcPath;
	}


	/**
	 * @return the className
	 */
	public String getClassName() {
		return className;
	}

	/**
	 * @return the startupMode
	 */
	public int getStartupMode() {
		return startupMode;
	}

	public static String toStartup(int mode,String defautValue) {
		if(mode==STARTUP_MODE_MANUAL) return "manual";
		else if(mode==STARTUP_MODE_DISABLED) return "disabled";
		else if(mode==STARTUP_MODE_AUTOMATIC) return "automatic";
		return defautValue;
	}

	public static int toStartup(String strMode, int defaultValue) {
		strMode=strMode.trim().toLowerCase();
		if("manual".equals(strMode)) return STARTUP_MODE_MANUAL;
		else if("disabled".equals(strMode)) return STARTUP_MODE_DISABLED;
		else if("automatic".equals(strMode)) return STARTUP_MODE_AUTOMATIC;
		return defaultValue;
	}
	
	@Override
	public boolean equals(Object obj){
		if(obj==this) return true;
		if(!(obj instanceof GatewayEntryImpl))return false;
		
		GatewayEntryImpl other=(GatewayEntryImpl) obj;
		if(!other.getId().equals(id)) return false;
		if(!equal(other.className,className)) return false;
		if(!equal(other.cfcPath,cfcPath)) return false;
		if(!equal(other.listenerCfcPath,listenerCfcPath)) return false;
		if(other.getStartupMode()!=startupMode) return false;
		
		Struct otherCustom = other.getCustom();
		if(otherCustom.size()!=custom.size()) return false;
		
		//Key[] keys = otherCustom.keys();
		Iterator<Entry<Key, Object>> it = otherCustom.entryIterator();
		Entry<Key, Object> e;
		Object ot,oc;
		while(it.hasNext()){
			e = it.next();
			ot=custom.get(e.getKey(),null);
			oc=e.getValue();
			if(ot==null) return false;
			if(!ot.equals(oc)) return false;
		}
		return true;
	}


	private static boolean equal(String left, String right) {
		if(left==null && right==null) return true;
		if(left!=null && right!=null) return left.equals(right);
		return false;
	}
}