xquery version "3.1" encoding "UTF-8";

module namespace titles="https://www.betamasaheft.uni-hamburg.de/BetMas/titles";

declare namespace t="http://www.tei-c.org/ns/1.0";
declare namespace sparql = "http://www.w3.org/2005/sparql-results#";
import module namespace xqjson="http://xqilla.sourceforge.net/lib/xqjson";
import module namespace config="https://www.betamasaheft.uni-hamburg.de/BetMas/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console";

 
(:establishes the different rules and priority to print a title referring to a record:)
declare function titles:printTitle($node as element()) {
(:always look at the root of the given node parameter of the function and then switch :)
   let $resource := root($node)
   return
   switch($resource//t:TEI/@type)
            case "mss"
                    return
                        if ($resource//objectDesc[@form = 'Inscription']) then
                            ($resource//t:msIdentifier/t:idno/text())
                        else
                            (
                                if($resource//t:repository/text() = 'Lost')
                                then ('Lost. ' || $resource//t:msIdentifier/t:idno/text())
                            else if ($resource//t:repository/@ref and $resource//t:msDesc/t:msIdentifier/t:idno/text())
                            then
                                let $repoid := $resource//t:repository/@ref
                                let $r := collection($config:data-rootIn)//id($repoid)
                                let $repo := if ($r) then
                                    ($r)
                                else
                                    'No Institution record'
                                
                                let $repoPlace :=
                                if ($repo = 'No Institution record') then
                                    $repo
                                else
                                    (if ($repo[not(.//t:settlement)][not(.//t:country)]) then ()
                                    else if ($repo//t:settlement[1]/@ref)
                                    then
                                         let $plaID := string($repo//t:settlement[1]/@ref)
                                         return 
                                              titles:decidePlName($plaID)
                                    else
                                        if ($repo//t:settlement[1]/text()) then
                                            $repo//t:settlement[1]/text()
                                        else
                                            if ($repo//t:country/@ref) then
                                                let $plaID := string($repo//t:country[1]/@ref) 
                                                return 
                                              titles:decidePlName($plaID)
                                        else if ($repo//t:country/text()) then
                                                $repo//t:country/text()
                                            else
                                                'No location record')
                                
                                return
                                    
                            string-join($repoPlace,' ') || ', ' ||
                                    (if ($repo = 'No Institution record') then
                                        $repo
                                    else
                                        (titles:placeNameSelector($repo))) || ', ' ||
                                    (if (contains($resource//t:msDesc/t:msIdentifier/t:idno/text(), ' ')) then
                                        substring-after($resource//t:msDesc/t:msIdentifier/t:idno/text(), ' ')
                                    else
                                        $resource//t:msDesc/t:msIdentifier/t:idno/text())
                            else
                                'no repository data for ' || string($resource/@xml:id)
                                
                                )
             case "place"  return  titles:placeNameSelector($resource)
             case "ins" return  titles:placeNameSelector($resource)
            case "pers"  return titles:persNameSelector($resource)
            case "work"  return titles:worknarrTitleSelector($resource)
            case "narr"  return titles:worknarrTitleSelector($resource)
(:            this should do also auths:)
            default return $resource//t:titleStmt/t:title[1]/text()
            
   };
   
   
declare function titles:printSubtitle($node as node(), $SUBid as xs:string) as xs:string {
    let $item := $node//id($SUBid)
    return
       if ($item/name() = 'title') then
            ($item/@xml:lang || $item)
        else
            if ($item/name() = 'msItem') then
                (if ($item/t:title/@ref)
                then
                    (titles:printTitleID(string($item/t:title/@ref)) || ' (in ' || $SUBid || ')')
                else
                    normalize-space(string-join(transform:transform($item/t:title,'xmldb:exist:///db/apps/BetMas/xslt/MixedTitles.xsl',()), ''))
                    )
            else 
            if ($item/t:label) then
                   normalize-space(string-join(transform:transform($item/t:label,'xmldb:exist:///db/apps/BetMas/xslt/MixedTitles.xsl',()), ''))
      
           else
                    if ($item/t:desc) then
                        (string($item/t:desc/@type) || ' ' || $SUBid)
             else
                        if ($item/@subtype) then
                            (string($item/@subtype) || ': ' || $SUBid)
             else
                            ($item/name() || ' ' || $SUBid)
};

(:this is now a switch function, deciding if to go ahead with simple print title or subtitles:)
declare function titles:printTitleID($id as xs:string)
{
    (: hack to avoid the bad usage of # at the end of an id like <title type="complete" ref="LIT2317Senodo#"
     : xml:lang="gez"> :) if (ends-with($id, '#')) then
        titles:printTitleMainID(substring-before($id, '#'))
    (: another hack for things like ref="#" :) else if ($id = '#') then
                         <span class="label label-warning">{ 'no item yet with id' || $id }</span>
    else if ($id = '') then
                        <span class="label label-warning">{ 'no id' }</span>
    (: if the id has a subid, than split it :) else if (contains($id, '#')) then
        let $mainID := substring-before($id, '#')
        let $SUBid := substring-after($id, '#')
        let $node := collection($config:data-root)//id($mainID)
        return
            (titles:printTitleMainID($mainID), ', ', titles:printSubtitle($node, $SUBid))
    (: if not, procede to main title printing :) else
        titles:printTitleMainID($id)
};





      declare function titles:printTitleMainID($id as xs:string)
   {
       if (starts-with($id, 'Q') or starts-with($id, 'gn:') or starts-with($id, 'pleiades:')) then
           (titles:decidePlaceNameSource($id))
       else (: always look at the root of the given node parameter of the function and then switch :)
           let $resource := collection($config:data-root)//id($id)
           return
               if (count($resource) = 0) then
           <span class="label label-warning">{ 'No item: ' || $id }</span>
               else if (count($resource) > 1) then
           <span class="label label-warning">{ 'More then 1 ' || $id }</span>
               else
                   switch ($resource/@type)
                       case "mss"
                           return if ($resource//objectDesc[@form = 'Inscription']) then
                               ($resource//t:msIdentifier/t:idno/text())
                           else
                               (if ($resource//t:repository/text() = 'Lost') then
                                   ('Lost. ' || $resource//t:msIdentifier/t:idno/text())
                               else if ($resource//t:repository/@ref and $resource//t:msDesc/t:msIdentifier/t:idno/text())
                                   then
                                   let $repoid := $resource//t:repository/@ref
                                   let $r := collection($config:data-rootIn)//id($repoid)
                                   let $repo :=
                                       if ($r) then
                                           ($r)
                                       else
                                           'No Institution record'
                                   let $repoPlace :=
                                       if ($repo = 'No Institution record') then
                                           $repo
                                       else
                                           (if ($repo//t:settlement[1]/@ref) then
                                               let $plaID := string($repo//t:settlement[1]/@ref)
                                               return
                                                   titles:decidePlName($plaID)
                                           else if ($repo//t:settlement[1]/text()) then
                                               $repo//t:settlement[1]/text()
                                           else if ($repo//t:country/@ref) then
                                               let $plaID := string($repo//t:country/@ref)
                                               return
                                                   titles:decidePlName($plaID)
                                           else if ($repo//t:country/text()) then
                                               $repo//t:country/text()
                                           else
                                               'No location record'
                                           )
                                   return
                                       string-join($repoPlace, ' ') || ', ' || (if ($repo = 'No Institution record') then
                                           $repo
                                       else
                                           (titles:placeNameSelector($repo))
                                       ) || ', ' || (if (contains($resource//t:msDesc/t:msIdentifier/t:idno/text(), ' '))
                                           then
                                           substring-after($resource//t:msDesc/t:msIdentifier/t:idno/text(), ' ')
                                       else
                                           $resource//t:msDesc/t:msIdentifier/t:idno/text()
                                       )
                               else
                                   'no repository data for ' || string($resource/@xml:id)
                               )
                   case "place"
                           return titles:placeNameSelector($resource)
                       case "ins"
                           return titles:placeNameSelector($resource)
                       case "pers"
                           return titles:persNameSelector($resource)
                       case "work"
                           return titles:worknarrTitleSelector($resource)
                       case "narr"
                           return titles:worknarrTitleSelector($resource) (: this should do also auths :)
                       default
                           return $resource//t:titleStmt/t:title[1]/text()
   };
   
   
   



declare function titles:placeNameSelector($resource as node()){
    let $pl := $resource//t:place
let $pnorm := $pl/t:placeName[@corresp = '#n1'][@type = 'normalized']
return
 if ($pnorm)
                        then
                            normalize-space(string-join($pnorm/text(), ' '))
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
let $Maintitle := $p/t:persName[@type = 'main'][@corresp = '#n1']
let $twonames:= $p/t:persName[t:forename or t:surname]
let $namegez := $p/t:persName[@corresp = '#n1'][@xml:lang = 'gez']
let $nameennorm := $p/t:persName[@corresp = '#n1'][@xml:lang = 'en'][@type = 'normalized']
let $nameen := $p/t:persName[@corresp = '#n1'][@xml:lang = 'en']
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
                                    if ($resource//t:person/t:persName[@xml:id])
                                    then
                                    let $name := $resource//t:person/t:persName[@xml:id = 'n1']
                                    return
                                        ($name/t:forename/text()
                                        || ' '
                                        || $name/t:surename/text())
                                    
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
                                                return $gname/text()
                                            
                                            else
                                                ($pg/t:persName[position() = 1]//text()))
                                
                                (:       otherways is just a normal person:)
                                 else
                             if ($Maintitle)
                        then
                            $Maintitle/text()
                            else
                                (
                                if ($namegez)
                                then
                                    $namegez//text()
                                
                                else
                                    if ($nameennorm)
                                    then
                                        $nameennorm//text()
                                    
                                    else
                                        if ($nameen)
                                        then
                                            $nameen//text()
                                        
                                        
                                        else
                                            if ($p/t:persName[@xml:id])
                                            then
                                                let $name := $p/t:persName[@xml:id = 'n1']
                                                return $name//text()
                                            
                                            else
                                                $p/t:persName[position() = 1][text()]//text()
                                )
};

declare function titles:worknarrTitleSelector($resource as node()){
    let $W := $resource//t:titleStmt
let $Maintitle := $W/t:title[@type = 'main'][@corresp = '#t1']
                    let $amarictitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'am']
                    let $geztitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'gez']
                    let $entitle := $W/t:title[@corresp = '#t1'][@xml:lang = 'en']
                    return
                        if ($Maintitle)
                        then
                            $Maintitle[1]/text()
                        else
                            if ($amarictitle)
                            then
                                $amarictitle[1]/text()
                            else
                                if ($geztitle)
                                then
                                    $geztitle[1]/text()
                                else
                                    if ($entitle)
                                    then
                                        $entitle[1]/text()
                                    else
                                        if ($W/t:title[@xml:id])
                                        then
                                            let $tit := $W/t:title[@xml:id = 't1']
                                            return $tit/text()
                                        else
                                            $W/t:title[1]/text()
};


declare function titles:decidePlName($plaID){
    if (starts-with($plaID, 'Q'))
        then titles:getwikidataNames($plaID) 
    else if (starts-with($plaID, 'gn:'))
        then titles:getGeoNames($plaID)
    else
        let $placefile := collection($config:data-rootPl)//id($plaID)
        return
            titles:placeNameSelector($placefile[1])
};

(:Given an id, decides if it is one of BM or from another source and gets the name accordingly:)
declare function titles:decidePlaceNameSource($pRef as xs:string) as xs:string{
if (contains($pRef, 'gn:')) then (titles:getGeoNames($pRef)) 
else if (starts-with($pRef, 'pleiades')) then (titles:getPleiadesNames($pRef)) 
else if (starts-with($pRef, 'Q')) then (titles:getwikidataNames($pRef)) 
else titles:printTitleID($pRef) 
};

declare function titles:getGeoNames ($string as xs:string){
let $gnid:= substring-after($string, 'gn:')
let $xml-url := concat('http://api.geonames.org/get?geonameId=',$gnid,'&amp;username=betamasaheft')
let $data := httpclient:get(xs:anyURI($xml-url), true(), <Headers/>)
return
if ($data//toponymName) then
$data//toponymName/text()
else ('no data from geonames', console:log($data))
};

declare function titles:getPleiadesNames($string as xs:string) {
   let $plid := substring-after($string, 'pleiades:')
   let $url := concat('http://pelagios.org/peripleo/places/http:%2F%2Fpleiades.stoa.org%2Fplaces%2F', $plid)
  let $file := httpclient:get(xs:anyURI($url), true(), <Headers/>)
  
let $file-info := 
    let $payload := util:base64-decode($file) 
    let $parse-payload := xqjson:parse-json($payload)
    return $parse-payload 
    return $file-info/*:pair[@name="title"]/text()

};

declare function titles:getwikidataNames($pRef as xs:string){
let $sparql := 'SELECT * WHERE {
  wd:' || $pRef || ' rdfs:label ?label . 
  FILTER (langMatches( lang(?label), "EN-GB" ) )  
}'


let $query := 'https://query.wikidata.org/sparql?query='|| xmldb:encode-uri($sparql)

let $req := httpclient:get(xs:anyURI($query), false(), <headers/>)
return
$req//sparql:result/sparql:binding[@name="label"]/sparql:literal[@xml:lang='en-gb']/text()
};
