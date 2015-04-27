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
 ---><cfoutput>
<script>

function selectAll(field) {
	var form=field.form;
	for(var key in form.elements){
		if((form.elements[key] && ""+form.elements[key].name).indexOf("path")==0){
			form.elements[key].checked=field.checked;
		}
	}
}
</script>

<h2>#lang.info#</h2>
#lang.descInfo#<br /><br />
<table class="tbl">
<tr>
    <td valign="top" class="tblHead">#lang.size#</td>
    <td valign="top" class="tblContent">#req.dspSize#</td>
</tr>
<tr>
    <td valign="top" class="tblHead">#lang.countDir#</td>
    <td valign="top" class="tblContent">#req.countDir#</td>
</tr>
<tr>
    <td valign="top" class="tblHead">#lang.countFile#</td>
    <td valign="top" class="tblContent">#req.countFile#</td>
</tr>
</table>
<br />

<h2>#lang.listing#</h2>
#lang.descListing#<br /><br />
<table class="tbl">
<cfform action="#action('delete')#" method="post">
    <tr>
        <td width="20"><input type="checkbox" class="checkbox" name="rowreadonly" onclick="selectAll(this)">
            </td>
        <td width="400" class="tblHead" nowrap>#lang.path#</td>
        <td width="100" class="tblHead" nowrap>#lang.size#</td>
        <td width="50" class="tblHead" nowrap>#lang.age#</td>
    </tr>
    <cfloop query="req.listing">
        <!--- and now display --->
    <tr>
        <td>
        <table border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
            <input type="checkbox" class="checkbox" name="path[]" value="#req.listing.path#">
            </td>
        </tr>
        </table>
        </td>
        <td class="tblContent" nowrap>#req.listing.path#</td>
        <td class="tblContent" nowrap>#req.listing.dspSize#</td>
        <td class="tblContent" nowrap>#dateFormat(req.listing.dateLastModified)# #TimeFormat(req.listing.dateLastModified)#</td>
    </tr>
    </cfloop>
    <tr>
        <td colspan="4">
         <table border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td>&nbsp;</td>		
            <td><cfmodule template="/lucee/admin/img.cfm" src="#request.adminType#-bgcolor.gif" width="1" height="20"></td>
            <td></td>
         </tr>
         <tr>
            <td></td>
            <td valign="top"><cfmodule template="/lucee/admin/img.cfm" src="#request.adminType#-bgcolor.gif" width="1" height="14"><cfmodule template="/lucee/admin/img.cfm" src="#request.adminType#-bgcolor.gif" width="36" height="1"></td>
             <td>&nbsp;
            <input type="submit" class="submit" name="delete" value="#lang.btnDelete#">
            </td>	
        </tr>
         </table>
         </td>
    </tr>
</cfform>
</table>

</cfoutput>