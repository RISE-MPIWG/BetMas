xquery version "3.1" encoding "UTF-8";

module namespace titles="https://www.betamasaheft.uni-hamburg.de/BetMas/titles";

declare namespace t="http://www.tei-c.org/ns/1.0";
declare namespace http = "http://expath.org/ns/http-client";
declare namespace test="http://exist-db.org/xquery/xqsuite";
declare namespace sparql = "http://www.w3.org/2005/sparql-results#";
import module namespace config="https://www.betamasaheft.uni-hamburg.de/BetMas/config" at "xmldb:exist:///db/apps/BetMas/modules/config.xqm";
import module namespace console="http://exist-db.org/xquery/console";
(: these lists are separately indexed here in the app with the collection.xconf for BetMas :)
declare variable $titles:placeNamesList := doc('/db/apps/BetMas/lists/placeNamesLabels.xml');
declare variable $titles:institutionsList := doc('/db/apps/BetMas/lists/institutions.xml');
declare variable $titles:persNamesList := doc('/db/apps/BetMas/lists/persNamesLabels.xml');
declare variable $titles:TUList := doc('/db/apps/BetMas/lists/textpartstitles.xml');
declare variable $titles:deleted := doc('/db/apps/BetMas/lists/deleted.xml');


(:establishes the different rules and priority to print a title referring to a record:)
declare function titles:printTitle($node as element()) {
(:always look at the root of the given node parameter of the function and then switch :)
   let $resource := root($node)
   return
   titles:switcher($resource//t:TEI/@type, $resource)
   };
   
   
(:looks for different possible locations of anchor and where to pick the correct label:)   
declare function titles:printSubtitle($node as node(), $SUBid as xs:string) as xs:string {
    if( starts-with($SUBid, 'tr')) then 'transformation ' ||  $SUBid
else if( starts-with($SUBid, 'Uni')) then $SUBid 
else
    let $item := $node//id($SUBid)
    return
       if ($item/name() = 'title') then
             (string($item/@xml:lang) || (if($item/text()) then $item/text() else ' ... empty, sorry!'))
        else
        if ($item/name() = 'persName') then
            
            (let $r := root($item)
            return
            if($r//t:persName[@type = 'normalized'][contains(@corresp,$SUBid)]) 
            then string-join($r//t:persName[@type = 'normalized'][contains(@corresp,$SUBid)]//text(), '')
            else normalize-space(string-join($item, ''))
            )
        else if ($item/name() = 'msItem') then
            (if ($item/t:title/@ref)
                then
                    (titles:printTitleID(string($item/t:title/@ref)) || ' (in ' || $SUBid || ')')
                else
                    normalize-space(string-join(titles:tei2string($item/t:title), ''))
                    )
            else if ($item/t:label) then
                let $sameAs := if ($item/@corresp) then (' (same as ' ||string($item/@corresp) || ')') else ()
                return
                   (normalize-space(string-join(titles:tei2string($item/t:label), '')) || $sameAs)
            else if ($item[not(t:label)]/@corresp) then
                   normalize-space(string-join(titles:printTitleID($item/@corresp), ''))
            else if ($item/t:desc) then
                    (titles:printTitleID(string($item/t:desc/@type)) || ' ' || $SUBid)
            else if (($item/@subtype = 'Monday' or $item/@subtype = 'Tuesday' or $item/@subtype = 'Wednesday' or $item/@subtype = 'Thursday' or $item/@subtype = 'Friday' or $item/@subtype = 'Saturday' or $item/@subtype = 'Sunday'    )and not($item/node())) then
                    (' for '|| $SUBid)
            else if ($item/@subtype) then
                    (titles:printTitleID(string($item/@subtype)) || ': ' || $SUBid)
            else ($item/name() || ' ' || $SUBid)
};

(:this is now a switch function, deciding if to go ahead with simple print title or subtitles:)
declare 
%test:arg('id', 'sdc:UniCont1') %test:assertEquals('La Synthaxe du Codex UniCont1')
%test:arg('id', 'LIT2317Senodo#') %test:assertEquals('Senodos')
%test:arg('id', '#') %test:assertEquals('&lt;span class="w3-tag w3-red"&gt;no item yet with id #&lt;/span&gt;')
%test:arg('id', '') %test:assertEquals('&lt;span class="w3-tag w3-red"&gt;no id&lt;/span&gt;')
%test:arg('id', 'BNFet32') %test:assertEquals('Paris, Bibliothèque nationale de France, BnF Éthiopien 32')
%test:arg('id', 'LIT1367Exodus') %test:assertEquals('Exodus')
%test:arg('id', 'PRS11160HabtaS') %test:assertEquals(' Habta Śǝllāse')
%test:arg('id', 'LOC1001Aallee') %test:assertEquals('Aallee')
%test:arg('id', 'BNFet32#a2') %test:assertEquals('Paris, Bibliothèque nationale de France, BnF Éthiopien 32, Donation Note a2')
%test:arg('id', 'BNFet32#e1') %test:assertEquals('Paris, Bibliothèque nationale de France, BnF Éthiopien 32, no id e1')
%test:arg('id', 'LIT1367Exodus#Ex1') %test:assertEquals('Exodus, Exodus 1')
%test:arg('id', 'PRS5684JesusCh#n2') %test:assertEquals('Jesus Christ, Krǝstos')
function titles:printTitleID($id as xs:string)
{ if ($titles:deleted//t:item[.=$id]) then
      let $del := $titles:deleted//t:item[.=$id]
      let $formerly := $config:collection-root//t:relation[@name='betmas:formerlyAlsoListedAs'][@passive=$id]
              return
              if($formerly) then
                titles:printTitleID($formerly/@active) || ' [now '||string($formerly/@active)||', formerly also listed as '||$id||', which was requested here but has been deleted on '||string($del/@change)||']'
                else $id || ' was permanently deleted' 
   else if (starts-with($id, 'sdc:')) then 'La Synthaxe du Codex ' || substring-after($id, 'sdc:' )
    (: another hack for things like ref="#" :) 
    else if ($id = '#') then <span class="w3-tag w3-red">{ 'no item yet with id ' || $id }</span>
    (: hack to avoid the bad usage of # at the end of an id like <title type="complete" ref="LIT2317Senodo#" xml:lang="gez"> :) 
    else if ($titles:TUList//t:item[@corresp = $id]) then ($titles:TUList//t:item[@corresp = $id][1]/node())
    else if ($titles:persNamesList//t:item[@corresp = $id]) then ($titles:persNamesList//t:item[@corresp = $id][1]/node())
    else if (ends-with($id, '#')) then (
                                let $newid := replace($id, '#', '') 
                                return titles:printTitleID($newid) )
    else if (matches($id, 'wd:Q\d+') or starts-with($id, 'gn:') or starts-with($id, 'pleiades:')) 
            then titles:decidePlaceNameSource($id)
    else if ($id = '') then <span class="w3-tag w3-red">{ 'no id' }</span>
    (: if the id has a subid, than split it :) 
    else if (contains($id, '#')) then
    (   let $mainID := substring-before($id, '#')
        let $SUBid := substring-after($id, '#')
        let $node := $config:collection-root//id($mainID)
        return
            if($node) then(
             if (starts-with($SUBid, 't')) then
                    (let $subtitles:=$node//t:title[contains(@corresp, $SUBid)]
                       let $subtitlemain := $subtitles[@type = 'main']/text()
                       let $subtitlenorm := $subtitles[@type = 'normalized']/text()
                         let $tit := $node//t:title[@xml:id = $SUBid]
                        return
                             if ($subtitlemain) then $subtitlemain
                            else if ($subtitlenorm) then $subtitlenorm
                            else $tit/text()
                 ) 
            else
(:            format the title, add it to the list and pass again to this function, which will have something to match now:)
                (let $subtitle := titles:printSubtitle($node, $SUBid)
                 let $name := (titles:printTitleMainID($mainID)|| ', '||$subtitle)   
                 let $addit := titles:updateTUList($name, $id)
                    return
                        titles:printTitleID($id)
                )
    )
    
    (: if no node could be found with the main id, that has a problem :)
     else 
        (<span class="w3-tag w3-red">{ 'No item: ' || $mainID 
            || ', could not check for ' || $SUBid
        }</span>)
    )    
       (: if not, procede to main title printing :)
    else
        titles:printTitleMainID($id)
};


declare function titles:printTitleMainID($id as xs:string, $c)
   {if (matches($id, 'wd:Q\d+') or starts-with($id, 'gn:') or starts-with($id, 'pleiades:')) then
           (titles:decidePlaceNameSource($id))
(:           because wikidata identifiers are not speaking, the result of this operation is that the
eventually added result is added to the place list names:)
       else (: always look at the root of the given node parameter of the function and then switch :)
           let $resource := collection($c)//id($id)
           let $resource := $resource[name() = 'TEI']
           return
               if (count($resource) = 0) then
           <span class="w3-tag w3-red">{ 'No item: ' || $id }</span>
               else if (count($resource) > 1) then
           <span class="w3-tag w3-red">{ 'More than 1 ' || $id }</span>
               else
                   titles:switcher($resource/@type, $resource)
   };
   
   
   
declare 
%test:arg('id', 'BNFet32') %test:assertEquals('Paris, Bibliothèque nationale de France, BnF Éthiopien 32')
%test:arg('id', 'LIT2317Senodo') %test:assertEquals('Senodos')
%test:arg('id', 'LIT1367Exodus') %test:assertEquals('Exodus')
%test:arg('id', 'PRS11160HabtaS') %test:assertEquals(' Habta Śǝllāse')
%test:arg('id', 'LOC1001Aallee') %test:assertEquals('Aallee')
function titles:printTitleMainID($id as xs:string)
   {   
       if (matches($id, 'wd:Q\d+') or starts-with($id, 'gn:') or starts-with($id, 'pleiades:')) 
    then
           (titles:decidePlaceNameSource($id))
    else (: always look at the root of the given node parameter of the function and then switch :)
           let $catchID := $config:collection-root/id($id)
           let $resource := $catchID[name() = 'TEI']
           return
               if (count($resource) = 0) then
           <span class="w3-tag w3-red">{ 'No item: ' || $id }</span>
               else if (count($resource) > 1) then
           <span class="w3-tag w3-red">{ 'More than 1 ' || $id }</span>
               else
                   let $type := string($resource/@type)
                   return
                titles:switcher($type, $resource)
   };
   
   declare function titles:switcher($type, $resource){
switch($type)
            case "mss"
                    return
                     titles:manuscriptLabelFormatter($resource)
             case "place"  return  titles:placeNameSelector($resource)
             case "ins" return  titles:placeNameSelector($resource)
            case "pers"  return titles:decidepersNameSource($resource, $resource/ancestor-or-self::t:TEI/@xml:id)
            case "work"  return titles:decideTUSource($resource, $resource/ancestor-or-self::t:TEI/@xml:id)
            case "narr"  return titles:decideTUSource($resource, $resource/ancestor-or-self::t:TEI/@xml:id)
(:            this should do also auths:)
            default return $resource//t:titleStmt/t:title[1]/text()
};

   
declare function titles:manuscriptLabelFormatter($resource) as xs:string {
   if ($resource//objectDesc[@form = 'Inscription']) 
       then ($resource//t:msIdentifier/t:idno/text())
    else (if ($resource//t:repository/text() = 'Lost') 
          then ('Lost. ' || $resource//t:msIdentifier/t:idno/text())
          else if ($resource//t:repository/@ref and $resource//t:msDesc/t:msIdentifier/t:idno/text())
                then
                    let $repoid := string(($resource//t:repository/@ref)[1])
                    let $reponame := $titles:institutionsList/id($repoid)[1]/text()
                    let $r := $config:collection-rootIn/id($repoid)
                    let $repo := if ($r) then ($r) else 'No Institution record'
                    let $repoPlace := if ($repo = 'No Institution record') then $repo else
                                        (if ($repo[not(descendant::t:settlement)][not(descendant::t:country)]) then ('No location record')
                                    else if ($repo//t:settlement[1]/@ref) then
                                               let $plaID := string($repo//t:settlement[1]/@ref)
                                               let $placeName := titles:decidePlaceNameSource($plaID)
                                               return $placeName
                                    else if ($repo//t:settlement[1]/text()) then $repo//t:settlement[1]/text()
                                    else if ($repo//t:country/@ref) then
                                               let $plaID := string($repo//t:country/@ref)
                                               return
                                                   titles:decidePlaceNameSource($plaID)
                                    else if ($repo//t:country/text()) then
                                               $repo//t:country/text()
                                    else 'No location record'
                                           )
                    let $candidate := string-join($repoPlace, ' ') || ', ' || (
                                     if ($repo = 'No Institution record') then $repo else ($reponame)
                                     ) || ', ' || 
                                           $resource//t:msDesc/t:msIdentifier/t:idno/text()
                    return normalize-space($candidate)
        else 'no repository data for ' || string($resource/@xml:id)
        )
};


declare function titles:placeNameSelector($resource as node()){
      let $pl := $resource//t:place
let $pnorm := $pl/t:placeName[@corresp = '#n1'][@type = 'normalized']
let $pEN := $pl/t:placeName[@corresp = '#n1'][@xml:lang='en']
return
 if ($pnorm)
                        then
                            normalize-space(string-join($pnorm/text(), ' '))
 else if ($pEN)
                        then
                            normalize-space(string-join($pEN/text(), ' '))
                        else
                            if ($pl/t:placeName[@xml:id])
                            then
                            let $pn := $pl/t:placeName[@xml:id = 'n1']
                            return
                                normalize-space($pn/text())
                            else
                                if ($pl/t:placeName[text()][position() = 1]/text())
                                then
                                    normalize-space($pl/t:placeName[text()][position() = 1]/text())
                                else
                                    $resource//t:titleStmt/t:title[text()]/text()
};

declare function titles:persNameSelector($resource as node()){
    let $p := $resource//t:person
    let $pg := $resource//t:personGrp
let $Maintitle := $p/t:persName[@type = 'main']
let $twonames:= $p/t:persName[t:forename or t:surname]
let $namegez := $p/t:persName[@corresp = '#n1'][@xml:lang = 'gez']
let $nameennorm := $p/t:persName[@corresp = '#n1'][@xml:lang = 'en'][@type = 'normalized']
let $nameen := $p/t:persName[@corresp = '#n1'][@xml:lang = 'en']
let $nameOthers := $p/t:persName[@corresp = '#n1'][@xml:lang[not(. = 'en')][not(. = 'gez')]]
let $group := $pg/t:persName
let $groupgez := $pg/t:persName[@corresp = '#n1'][@xml:lang = 'gez']
let $groupennorm := $pg/t:persName[@corresp = '#n1'][@xml:lang = 'en'][@type = 'normalized']

return
 (:            first check for persons with two names:)
                        if ($twonames) then
                            (
                            if ($namegez)
                            then
                                ($namegez/t:forename/text()
                                || ' ' || $namegez/t:surname/text())
                            
                           
                            else
                                if ($nameennorm)
                                then
                                    ($nameennorm/t:forename/text()
                                    || ' ' || $nameennorm/t:surname/text())
                             else
                                if ($nameOthers)
                                then
                                    ($nameOthers[1]/t:forename/text()
                                    || ' ' || $nameOthers[1]/t:surname/text())
                                
                                else
                                    if ($resource//t:person/t:persName[@xml:id])
                                    then
                                    let $name := $resource//t:person/t:persName[@xml:id = 'n1']
                                    return
                                        ($name/t:forename/text()
                                        || ' '
                                        || $name/t:surname/text())
                                    
                                    else
                                        ($p/t:persName[position() = 1]/t:forename[1]/text() || ' '
                                        || $p/t:persName[position() = 1]/t:surname[1]/text()))
                            
                            (:       then check if it is a personGrp:)
                        else
                            if ($group) then
                                (
                                if ($groupgez)
                                then
                                    $groupgez/text()
                                
                                
                                else
                                    if ($pg/t:persName[t:orgName])
                                    then
                                        let $gname:=$pg/t:persName[@xml:id = 'n1']
                                        return $gname/t:orgName/text()
                                    
                                    
                                    else
                                        if ($groupennorm)
                                        then
                                            $groupennorm
                                        
                                        else
                                            if ($pg/t:persName[@xml:id])
                                            then
                                                let $gname:=$pg/t:persName[@xml:id = 'n1']
                                                return string-join($gname/text())
                                            
                                            else
                                                ($pg/t:persName[position() = 1]//text()))
                                
                                (:       otherways is just a normal person:)
                                 else
                            if ($Maintitle)
                        then
                            string-join($Maintitle/text())
                            else
                                (
                                if ($namegez)
                                then
                                    string-join($namegez//text())
                                
                                else
                                    if ($nameennorm)
                                    then
                                        string-join($nameennorm//text())
                                    
                                    else
                                        if ($nameen)
                                        then
                                            string-join($nameen//text())
                                    else
                                      if ($nameOthers)
                                        then
                                    string-join($nameOthers[1]/text())
                                   
                                        
                                        else
                                            if ($p/t:persName[@xml:id])
                                            then
                                                let $name := $p/t:persName[@xml:id = 'n1']
                                                return string-join($name//text())
                                            
                                            else
                                                string-join($p/t:persName[position() = 1][text()]//text())
                                )
};

declare function titles:worknarrTitleSelector($resource as node()){
    let $W := $resource//t:titleStmt
let $Maintitle := $W/t:title[@type = 'main'][@corresp = '#t1'][text()]
                    let $amarictitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'am' or @xml:lang = 'ar']
                    let $geztitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'gez']
                    let $entitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'en']
                    return
                        if ($Maintitle)
                        then
                            titles:normalize($Maintitle[1])
                        else
                            if ($amarictitle)
                            then
                                titles:normalize($amarictitle[1])
                            else
                                if ($geztitle)
                                then
                                    titles:normalize($geztitle[1])
                                else
                                    if ($entitle)
                                    then
                                        titles:normalize($entitle[1])
                                    else
                                        if ($W/t:title[@xml:id])
                                        then
                                            let $tit := $W/t:title[@xml:id = 't1']
                                            return titles:normalize($tit)
                                        else
                                            titles:normalize($W/t:title[1])
};

declare function titles:normalize($nodes){
let $tostring := $nodes/string()
return
normalize-space(string-join($tostring))
};

declare function titles:decidePlName($plaID){
    if (starts-with($plaID, 'wd:'))
        then titles:getwikidataNames($plaID) 
    else if (starts-with($plaID, 'gn:'))
        then titles:getGeoNames($plaID)
    else
        let $placefile := $config:collection-rootPl/id($plaID)
        return
            titles:placeNameSelector($placefile[1])
};

(:Given an id, decides if it is one of BM or from another source and gets the name accordingly:)
declare function titles:decidePlaceNameSource($pRef as xs:string){
   
if ($titles:placeNamesList//t:item[@corresp = $pRef]) 
    then $titles:placeNamesList//t:item[@corresp = $pRef][1]/text()
else if (starts-with($pRef, 'gn:')) then (
        let $name := titles:getGeoNames($pRef) 
        let $addit := titles:updatePlaceList($name, $pRef) 
        return
        titles:decidePlaceNameSource($pRef)) 
else if (starts-with($pRef, 'pleiades:')) then (
        let $name := titles:getPleiadesNames($pRef) 
        let $addit := titles:updatePlaceList($name, $pRef) 
        return
            titles:decidePlaceNameSource($pRef)) 
else if (matches($pRef, 'wd:Q\d+')) then (
        let $name := titles:getwikidataNames($pRef) 
    let $test := console:log($name)
        let $addit := titles:updatePlaceList($name, $pRef) 
        return
            titles:decidePlaceNameSource($pRef)) 
else (
    let $resource := $config:collection-rootPl/id($pRef)
    return titles:placeNameSelector($resource)
    )
};

(:Given an id, decides if it is one of BM or from another source and gets the name accordingly:)
declare function titles:decidepersNameSource($resource, $pRef as xs:string){
if ($titles:persNamesList//t:item[@corresp = $pRef]) 
    then $titles:persNamesList//t:item[@corresp = $pRef][1]/text()
else if (matches($pRef, 'wd:Q\d+')) then (
    let $name := titles:getwikidataNames($pRef) 
    let $test := console:log($name)
    let $addit := titles:updatePersList($name, $pRef) 
    return titles:decidepersNameSource($resource, $pRef)
    ) 
else 
  let $name := titles:persNameSelector($resource)
  let $addit := titles:updatePersList($name, $pRef)
  return titles:decidepersNameSource($resource, $pRef)
};

(:Given an id, decides if it is one of BM or from another source and gets the name accordingly:)
declare function titles:decideTUSource($resource, $pRef as xs:string){
if ($titles:TUList//t:item[@corresp = $pRef]) 
    then $titles:TUList//t:item[@corresp = $pRef][1]/text()
else 
  let $name := titles:worknarrTitleSelector($resource)
  let $addit := titles:updateTUList($name, $pRef)
  return titles:decideTUSource($resource, $pRef)
};

declare function titles:updatePlaceList($name, $pRef){
let $placeslist := $titles:placeNamesList//t:list
return 
update insert <item 
xmlns="http://www.tei-c.org/ns/1.0" 
change="entryAddedAt{current-dateTime()}"
corresp="{$pRef}">{$name}</item> into  $placeslist
};

declare function titles:updatePersList($name, $pRef){
let $perslist := $titles:persNamesList//t:list
return 
update insert <item 
xmlns="http://www.tei-c.org/ns/1.0" 
change="entryAddedAt{current-dateTime()}"
corresp="{$pRef}">{$name}</item> into  $perslist
};

declare function titles:updateTUList($name, $pRef){
let $TUlist := $titles:TUList//t:list
return 
update insert <item 
xmlns="http://www.tei-c.org/ns/1.0" 
change="entryAddedAt{current-dateTime()}"
corresp="{$pRef}">{$name}</item> into  $TUlist
};


declare function titles:getGeoNames ($string as xs:string){
let $gnid:= substring-after($string, 'gn:')
let $xml-url := concat('http://api.geonames.org/get?geonameId=',$gnid,'&amp;username=betamasaheft')
let $data := try{let $request := <http:request href="{xs:anyURI($xml-url)}" method="GET"/>
    return http:send-request($request)[2]} catch *{$err:description}
return
if ($data//toponymName) then
$data//toponymName/text()
else 'no data from geonames'
};

declare function titles:getPleiadesNames($string as xs:string) {

   let $plid := substring-after($string, 'pleiades:')
   let $url := concat('http://pelagios.org/peripleo/places/http:%2F%2Fpleiades.stoa.org%2Fplaces%2F', $plid)
  let $file := try{let $request := <http:request href="{xs:anyURI($url)}" method="GET"/>
    return http:send-request($request)[2]} catch *{$err:description}
  
let $file-info := 
    let $payload := util:base64-decode($file) 
    let $parse-payload := parse-json($payload)
    return $parse-payload 
    return $file-info?title

};

declare function titles:getwikidataNames($pRef as xs:string){
let $pRef := substring-after($pRef, 'wd:')
let $sparql := 'SELECT * WHERE {
  wd:' || $pRef || ' rdfs:label ?label . 
  FILTER (langMatches( lang(?label), "EN" ) )  
}'


let $query := 'https://query.wikidata.org/sparql?query='|| xmldb:encode-uri($sparql)

let $req := try{let $request := <http:request href="{xs:anyURI($query)}" method="GET"/>
    return http:send-request($request)[2]} catch * {$err:description}
return
$req//sparql:result/sparql:binding[@name="label"]/sparql:literal[@xml:lang='en']/text()
};


(:takes a node as argument and loops through each element it contains. if it matches one of the definitions it does that, otherways checkes inside it. This actually reproduces the logic of the apply-templates function in  xslt:)
declare function titles:tei2string($nodes as node()*) {
    
    for $node in $nodes
    return
        typeswitch ($node)
        case element(t:title)
                return
                    titles:printTitleMainID($node/@ref)
        case element(t:persName)
                return
                    titles:printTitleMainID($node/@ref)
         case element(t:placeName)
                return
                    titles:printTitleMainID($node/@ref)                     
            case element()
                return
                    titles:tei2string($node/node())
            default
                return
                    $node
};
