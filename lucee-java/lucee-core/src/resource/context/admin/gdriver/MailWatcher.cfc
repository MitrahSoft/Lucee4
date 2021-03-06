<!--- 
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
 ---><cfcomponent extends="Gateway">

	
    <cfset fields=array(
		field("Server","server","",true,"the pop server to access","text")
		,field("Port","port","110",true,"port of the server","text")
		,field("User Name","username","",false,"the username to access the server","text")
		,field("Password","password","",false,"the password to access the server","password")
		,field("Attachment path","attachmentpath",expandPath('{temp-directory}/mailwatcher-attachments'),false,"a directory in which to save any attachments","text")
		,field("Interval (ms)","interval","60000",true,"The interval between checks, in miliseconds","text")
		
		,group("CFC Listener Function Definition","Definition for the CFC Listener Function, when empty no listener is called",3)
		
		,field("Function Name","functionName","invoke",false,"function to call when there is a new mail","text")
		
		
	)>
    
       
    

	<cffunction name="getClass" returntype="string">
    	<cfreturn "">
    </cffunction>
	<cffunction name="getCFCPath" returntype="string">
    	<cfreturn "lucee.extension.gateway.MailWatcher">
    </cffunction>
    
	<cffunction name="getLabel" returntype="string" output="no">
    	<cfreturn "Mail Watcher">
    </cffunction>
	<cffunction name="getDescription" returntype="string" output="no">
    	<cfreturn "Watch a certain (Pop) mail sever for new mails">
    </cffunction>
    
	<cffunction name="onBeforeUpdate" returntype="void" output="false">
		<cfargument name="cfcPath" required="true" type="string">
		<cfargument name="startupMode" required="true" type="string">
		<cfargument name="custom" required="true" type="struct">
        <cfset custom.functionName=trim(custom.functionName)>
        <cfif not IsNumeric(custom.port)>
        	<cfthrow message="port [#custom.port#] is not a numeric value">
        <cfelseif not IsNumeric(custom.interval)>
        	<cfthrow message="interval [#custom.interval#] is not a numeric value">
        <cfelseif custom.interval LT 1>
        	<cfthrow message="interval [#custom.interval#] must be a positive number greater than 0">
        <cfelseif len(custom.functionName) and not IsValid("variablename",custom.functionName)>
        	<cfthrow message="function name [#custom.functionName#] is not valid">
        </cfif>
        
        <cfif len(custom.attachmentpath)>
        	<cfif not DirectoryExists(custom.attachmentpath)>
            	<cfdirectory directory="#custom.attachmentpath#" action="create" mode="777">
            </cfif>
        </cfif>
        
        
	</cffunction>
    
    
	<cffunction name="getListenerCfcMode" returntype="string" output="no">
		<cfreturn "required">
	</cffunction>
	<cffunction name="getListenerPath" returntype="string" output="no">
		<cfreturn "lucee.extension.gateway.MailWatcherListener">
	</cffunction>
</cfcomponent>