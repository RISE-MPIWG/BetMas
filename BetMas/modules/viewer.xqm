xquery version "3.1" encoding "UTF-8";


module namespace viewer = "https://www.betamasaheft.uni-hamburg.de/BetMas/iiifviewer";
import module namespace rest = "http://exquery.org/ns/restxq";
import module namespace log="http://www.betamasaheft.eu/log" at "xmldb:exist:///db/apps/BetMas/modules/log.xqm";
import module namespace xdb="http://exist-db.org/xquery/xmldb";
import module namespace config = "https://www.betamasaheft.uni-hamburg.de/BetMas/config" at "xmldb:exist:///db/apps/BetMas/modules/config.xqm";
import module namespace nav = "https://www.betamasaheft.uni-hamburg.de/BetMas/nav" at "xmldb:exist:///db/apps/BetMas/modules/nav.xqm";
import module namespace item2 = "https://www.betamasaheft.uni-hamburg.de/BetMas/item2" at "xmldb:exist:///db/apps/BetMas/modules/item.xqm";
import module namespace error = "https://www.betamasaheft.uni-hamburg.de/BetMas/error" at "xmldb:exist:///db/apps/BetMas/modules/error.xqm";
import module namespace apprest = "https://www.betamasaheft.uni-hamburg.de/BetMas/apprest" at "xmldb:exist:///db/apps/BetMas/modules/apprest.xqm";
import module namespace switch2 = "https://www.betamasaheft.uni-hamburg.de/BetMas/switch2"  at "xmldb:exist:///db/apps/BetMas/modules/switch2.xqm";
declare namespace t = "http://www.tei-c.org/ns/1.0";
declare namespace marc = "http://www.loc.gov/MARC21/slim";
(: For REST annotations :)
declare namespace http = "http://expath.org/ns/http-client";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";



declare 
%rest:GET
%rest:path("/BetMas/manuscripts/viewer")
%output:method("html5")
function viewer:allmirador(){
 (
log:add-log-message('/manuscripts/viewer', xmldb:get-current-user(), 'viewer'),
<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
        
        
       <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="shortcut icon" href="resources/images/minilogo.ico"/>
<title xmlns="http://www.w3.org/1999/xhtml" property="dcterms:title og:title schema:name" >Mirador Manuscript viewer</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" type="text/css" href="resources/mirador/css/mirador-combined.css"/>
    <script src="resources/mirador/mirador.min.js"></script>
    
     
    </head>
    <body id="body">
       <div id="content" class="w3-container w3-padding-64 w3-margin">
 
    <div id="viewer"></div>
    
<script type="text/javascript" >{'var data = [{collectionUri: "' ||$config:appUrl|| '/api/iiif/collections"}]'}</script>
   <script type="text/javascript" src="resources/js/miradorcoll.js"></script>
 </div>
        
    
    </body>
</html>
        )
        
};



declare 
%rest:GET
%rest:path("/BetMas/manuscripts/{$repoid}/list/viewer")
%output:method("html5")
function viewer:allinRepo($repoid as xs:string){
 (
log:add-log-message('/manuscripts/'||$repoid||'/viewer', xmldb:get-current-user(), 'viewer'),
<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
        
        
       <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="shortcut icon" href="resources/images/favicon.ico"/>
<title xmlns="http://www.w3.org/1999/xhtml" property="dcterms:title og:title schema:name" >Mirador Manuscript viewer</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" type="text/css" href="resources/mirador/css/mirador-combined.css"/>
    <script src="resources/mirador/mirador.min.js"></script>
    
     
    </head>
    <body id="body">
       <div id="content" class="w3-margin w3-container w3-padding-64">
 
    <div id="viewer"></div>
    
<script type="text/javascript" >{'var data = [{collectionUri: "' ||$config:appUrl|| '/api/iiif/collection/'||$repoid||'"}]'}</script>
   <script type="text/javascript" src="resources/js/miradorcoll.js"></script>
 </div>
        
    
    </body>
</html>
        )
        
};





declare 
%rest:GET
%rest:path("/BetMas/{$collection}/{$id}/viewer")
%rest:query-param("FirstCanv", "{$FirstCanv}", '')
%output:method("html5")
function viewer:mirador($collection as xs:string, $id as xs:string, $FirstCanv as xs:string*){

let $c := switch2:collectionVar($collection)
let $coll := $config:data-root || '/' || $collection
let $this := $c/id($id)
let $biblio :=
<bibl>
{let $time := max($this//t:revisionDesc/t:change/xs:date(@when))
return
<date type="lastModified">{format-date($time, '[D].[M].[Y]')}</date>
}
<idno type="url">
{($config:appUrl ||'/'|| $collection||'/' ||$id)}
</idno>
<coll>{$collection}</coll>
</bibl>
let $manifest := 
(:ES:)
            if($this//t:collection = 'Ethio-SPaRe' or $this//t:collection = 'EMIP' or $this//t:repository/@ref = 'INS0339BML') 
            then $config:appUrl|| '/api/iiif/' || $id || '/manifest' 
            (:BNF:)
            else if ($this//t:repository/@ref = 'INS0303BNF') 
            then replace($this//t:msIdentifier/t:idno/@facs, 'ark:', 'iiif/ark:') || '/manifest.json'
(:           vatican :)
            else replace($this//t:msIdentifier/t:idno/@facs, 'http:', 'https:')

let $location := 
(:ES:)
            if($this//t:collection = 'Ethio-SPaRe' or $this//t:collection = 'EMIP') 
            then $this//t:collection  
            (:BNF:)
            else if ($this//t:repository/@ref = 'INS0303BNF') 
            then 'BnF'
            else if ($this//t:repository/@ref = 'INS0339BML')
            then 'Biblioteca Medicea Laurenziana'
(:           vatican :)
            else  'Biblioteca Apostolica Vaticana'

let $firstcanvas := 
(:es:)
                if($this//t:collection = 'Ethio-SPaRe' or $this//t:collection = 'EMIP' or $this//t:repository/@ref = 'INS0339BML') 
               then $config:appUrl|| '/api/iiif/' || $id || '/canvas/p1' 
               (:BNF:)
            else if ($this//t:repository/@ref = 'INS0303BNF') 
            then replace($this//t:msIdentifier/t:idno/@facs, 'ark:', 'iiif/ark:') || '/canvas/f1'
(:           vatican :)
                else replace(substring-before($this//t:msIdentifier/t:idno/@facs, '/manifest.json') || '/canvas/p0001', 'http:', 'https:')
                
                
let $Cmap := map {'type':= 'collection', 'name' := $collection, 'path' := $c}
let $Imap := map {'type':= 'item', 'name' := $id, 'path' := $collection}
return 


if(xdb:collection-available($coll)) then (
(:check that it is one of our collections:)
 if ($collection='institutions') then (
 (:controller should handle this by redirecting /institutions/ID/main to /manuscripts/ID/list which is then taken care of by list.xql:)
 )
        else
(:        check that the item exists:)
       if($config:collection-root/id($id)[name() = 'TEI']) then (
       log:add-log-message('/'||$collection||'/'||$id||'/viewer', xmldb:get-current-user(), 'viewer'),

<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
       <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    {apprest:app-title($id)}
        <link rel="shortcut icon" href="resources/images/favicon.ico"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  {apprest:app-meta($biblio)}
     {apprest:scriptStyle()}
    <link rel="stylesheet" type="text/css" href="resources/mirador/css/mirador-combined.css"/>
    <script src="resources/mirador/mirador.min.js"></script>
    </head>
    <body id="body">
      {nav:barNew()}
        {nav:modalsNew()}
        {nav:searchhelpNew()}
        <div id="content" class="w3-container w3-padding-48">
       {item2:RestViewOptions($this, $collection)}
  { item2:RestItemHeader($this, $collection)}
       <div class="w3-container">
 
    <div id="viewer" class="w3-margin-top" allowfullscreen="allowfullscreen"></div>
    
<script type="text/javascript" >{'var data = [{manifestUri: "' || $manifest || '", location: "' || $location || '"}]
var loadedM =  "' || $manifest || '"
var canvasid = "' || (if($FirstCanv = '') then $firstcanvas else $FirstCanv) || '"
'}</script>
   <script type="text/javascript" src="resources/js/mirador.js"></script>
   
 </div>
 <div class="w3-panel w3-gray w3-card-2">
 <p><a href="{$manifest}" target="_blank"><img src="/resources/images/iiif.png" width="20px"/> {$manifest}</a></p>
 </div>
        { apprest:authors($this, $collection)}
        </div>
     {nav:footerNew()}
    </body>
</html>
        )
        else
       (<rest:response>
            <http:response
                status="400">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
        error:error($Imap)) 
       
        )
        else
        (
        <rest:response>
            <http:response
                status="400">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
        error:error($Cmap)
        )
};


declare 
%rest:GET
%rest:path("/BetMas/chojnacki/viewer")
%output:method("html5")
function viewer:allchojnacki(){
 (
log:add-log-message('/chojnacki/viewer', xmldb:get-current-user(), 'viewer'),
<rest:response>
            <http:response
                status="200">
                <http:header
                    name="Content-Type"
                    value="text/html; charset=utf-8"/>
            </http:response>
        </rest:response>,
        
        
       <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="shortcut icon" href="resources/images/minilogo.ico"/>
<title xmlns="http://www.w3.org/1999/xhtml" property="dcterms:title og:title schema:name" >Mirador Chojnacki images viewer</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" type="text/css" href="resources/mirador/css/mirador-combined.css"/>
    <script src="resources/mirador/mirador.min.js"></script>
    
     
    </head>
    <body id="body">
       <div id="content" class="w3-container w3-padding-64 w3-margin">
 
    <div id="viewer"></div>
    
<script type="text/javascript" >{
let $manifs := for $ch in $config:collection-rootCh//marc:record
let $segnatura := $ch//marc:datafield[@tag="852"]/marc:subfield[@code="h"]/text()
return
'{"manifestUri": "https://digi.vatlib.it/iiif/STP_'||string-join($segnatura)||'/manifest.json", "location" : "DigiVatLib"}'

let $chmanif:= string-join($manifs, ',')
return 'var data = [' ||$chmanif||']'}</script>
   <script type="text/javascript" src="resources/js/miradorcoll.js"></script>
 </div>
        
    
    </body>
</html>
        )
        
};
