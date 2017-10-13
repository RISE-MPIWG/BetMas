xquery version "3.1";
(:~
 : This module based on the one provided in the shakespare example app
 : produces a xslfo temporary object and passes it to FOP to produce a PDF
 : @author Pietro Liuzzo <pietro.liuzzo@uni-hamburg.de'>
 :)
 
import module namespace config = "https://www.betamasaheft.uni-hamburg.de/BetMas/config" at "config.xqm";
import module namespace titles = "https://www.betamasaheft.uni-hamburg.de/BetMas/titles" at "titles.xqm";
import module namespace app = "https://www.betamasaheft.uni-hamburg.de/BetMas/app" at "app.xqm";
import module namespace coord = "https://www.betamasaheft.uni-hamburg.de/BetMas/coord" at "coordinates.xql";
import module namespace console = "http://exist-db.org/xquery/console";
import module namespace http = "http://expath.org/ns/http-client" at "java:org.exist.xquery.modules.httpclient.HTTPClientModule";

declare namespace fo = "http://www.w3.org/1999/XSL/Format";
declare namespace xslfo = "http://exist-db.org/xquery/xslfo";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace file = "http://exist-db.org/xquery/file";
declare namespace functx = "http://www.functx.com";

declare function functx:capitalize-first($arg as xs:string?) as xs:string? {
    
    concat(upper-case(substring($arg, 1, 1)),
    substring($arg, 2))
};
declare variable $local:fop-config :=
let $fontsDir := config:get-fonts-dir()
let $test := console:log($fontsDir)
return
    <fop
        version="1.0">
        <strict-configuration>true</strict-configuration>
        <strict-validation>false</strict-validation>
        <base>./</base>
        <renderers>
            <renderer
                mime="application/pdf">
                <fonts>
                    {
                        if ($fontsDir) then
                            (
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/Cardo-Regular.ttf">
                                <font-triplet
                                    name="Cardo"
                                    style="normal"
                                    weight="normal"/>
                            </font>, <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/Cardo-Bold.ttf">
                                <font-triplet
                                    name="Cardo"
                                    style="normal"
                                    weight="700"/>
                            </font>, <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/Cardo-Italic.ttf">
                                <font-triplet
                                    name="Cardo"
                                    style="italic"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/coranica_1145.ttf">
                                <font-triplet
                                    name="coranica"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/TitusCBZ.TTF">
                                <font-triplet
                                    name="Titus"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/LudolfusNormal.ttf">
                                <font-triplet
                                    name="Ludolfus"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/LudolfusBold.ttf">
                                <font-triplet
                                    name="Ludolfus"
                                    style="normal"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/LudolfusItalic.ttf">
                                <font-triplet
                                    name="Ludolfus"
                                    style="italic"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/LudolfusBoldItalic.ttf">
                                <font-triplet
                                    name="Ludolfus"
                                    style="italic"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSans-Regular.ttf">
                                <font-triplet
                                    name="Noto"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSans-Bold.ttf">
                                <font-triplet
                                    name="Noto"
                                    style="normal"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSans-Italic.ttf">
                                <font-triplet
                                    name="Noto"
                                    style="italic"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSans-BoldItalic.ttf">
                                <font-triplet
                                    name="Noto"
                                    style="italic"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansEthiopic-Regular.ttf">
                                <font-triplet
                                    name="NotoSansEthiopic"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansEthiopic-Bold.ttf">
                                <font-triplet
                                    name="NotoSansEthiopic"
                                    style="normal"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoNaskhArabic-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoNaskhArabic"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoNaskhArabic-Bold.ttf">
                                
                                <font-triplet
                                    name="NotoNaskhArabic"
                                    style="normal"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansArmenian-Bold.ttf">
                                
                                <font-triplet
                                    name="NotoSansArmenian"
                                    style="normal"
                                    weight="700"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansArmenian-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansArmenian"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansAvestan-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansAvestan"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansCoptic-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansCoptic"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansGeorgian-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansGeorgian"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansHebrew-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansHebrew"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansSyriacEstrangela-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansSyriacEstrangela"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansDevanagari-Regular.ttf">
                                
                                <font-triplet
                                    name="NotoSansDevanagari"
                                    style="normal"
                                    weight="normal"/>
                            </font>,
                            <font
                                kerning="yes"
                                embed-url="file:{$fontsDir}/NotoSansDevanagari-bold.ttf">
                                
                                <font-triplet
                                    name="NotoSansDevanagari"
                                    style="normal"
                                    weight="700"/>
                            </font>
                            )
                        else
                            ()
                    }
                </fonts>
            </renderer>
        </renderers>
    </fop>
;

declare function fo:Zotero($ZoteroUniqueBMtag as xs:string) {
    let $xml-url := concat('https://api.zotero.org/groups/358366/items?tag=', $ZoteroUniqueBMtag, '&amp;format=bib&amp;style=http://www1.uni-hamburg.de/ethiostudies/hiob-ludolf-centre-for-ethiopian-studies-web.csl&amp;linkwrap=1')
    let $data := httpclient:get(xs:anyURI($xml-url), true(), <Headers/>)
    let $datawithlink := fo:tei2fo($data//div[@class = 'csl-entry'])
    return
        $datawithlink
};
declare function fo:lang($lang as xs:string) {
    switch ($lang)
        case 'ar'
            return
                (attribute font-family {'coranica'}, attribute writing-mode {'rl'})
        case 'he'
            return
                (attribute font-family {'Titus'}, attribute writing-mode {'rl'})
        case 'syr'
            return
                (attribute font-family {'Titus'}, attribute writing-mode {'rl'})
        case 'grc'
            return
                attribute font-family {'Cardo'}
       case 'cop'
            return
                attribute font-family {'Titus'}
        case 'gez'
            return
                (attribute font-family {'Ludolfus'}, attribute letter-spacing {'0.5pt'}, attribute font-size {'0.9em'})
        case 'sa'
            return
                attribute font-family {'NotoSansDevanagari'}
        default return
            attribute font-family {'Ludolfus'}
};
declare function fo:entitiesWithRef($node) {
    <fo:inline>
        
        {
            if ($node/@target and not($node/text())) then
                if (starts-with($node/@target, '#')) then
                    <fo:basic-link
                        internal-destination="{substring-after($node/@target, '#')}">↗{substring-after($node/@target, '#')}</fo:basic-link>
                else
                    <fo:basic-link
                        external-destination="{$node/@target}">[↗]</fo:basic-link>
            else
                if ($node/@target and $node/text()) then
                    <fo:basic-link
                        external-destination="{$node/@target}">{$node/text()}</fo:basic-link>
                else
                    if ($node/@ref and $node/text()) then
                        <fo:basic-link
                            external-destination="{$config:appUrl || '/' || string($node/@ref) || '/main'}">↗{$node/text()}</fo:basic-link>
                    
                    else
                        if ($node/text()) then
                            (
                            let $lang := if ($node/@xml:lang) then
                                $node/@xml:lang
                            else
                                $node/following-sibling::tei:textLang/@mainLang
                            return
                                if ($lang) then
                                    fo:lang($lang)
                                else
                                    (),
                            
                            fo:tei2fo($node/node()))
                        else
                            if ($node/@ref) then
                                <fo:basic-link
                                    external-destination="{$config:appUrl || '/' || string($node/@ref) || '/main'}">↗{titles:printTitleID($node/@ref)}</fo:basic-link>
                            
                            else
                                'no title provided'
        }
    </fo:inline>
};
declare function fo:tei2fo($nodes as node()*) {
    for $node in $nodes
    return
        typeswitch ($node)
            case element(a)
                return
                    <fo:basic-link
                        external-destination="{string($node/@href)}">{$node/text()}</fo:basic-link>
            case element(i)
                return
                    <fo:inline
                        font-style="italic">{$node/text()}</fo:inline>
            
            case element(tei:gap)
                
                return
                    switch ($node/@reason)
                        case 'illegible'
                            return
                                for $c in 0 to $node/@quantity
                                return
                                    <fo:inline>+</fo:inline>
                        case 'omitted'
                            return
                                <fo:inline>.....</fo:inline>
                        case 'ellipsis'
                            return
                                <fo:inline>(...)</fo:inline>
                        default return
                            <fo:inline>[- ca. {(string($node/@quantity) || ' ' || string($node/@unit))}{
                                    if (xs:integer($node/@quantity) gt 1) then
                                        's'
                                    else
                                        ()
                                } -]</fo:inline>
        case element(tei:supplied)
            return
                switch ($node/@reason)
                    case 'omitted'
                        return
                            <fo:inline>&lt;{fo:tei2fo($node/node())}&gt;</fo:inline>
                    case 'undefined'
                        return
                            <fo:inline>[{fo:tei2fo($node/node())} (?)]</fo:inline>
                    default return
                        <fo:inline>[{fo:tei2fo($node/node())}]</fo:inline>
    case element(tei:add)
        return
            fo:tei2fo($node/node())
    case element(tei:handShift)
        return
            fo:tei2fo($node/node())
    case element(tei:hi)
        return
            if ($node/@rend = "rubric") then
                <fo:inline
                    color="red">{$node/text()}</fo:inline>
            else
                fo:tei2fo($node/node())
    case element(tei:certainty)
        return
            <fo:inline>(?)</fo:inline>
    case element(tei:relation)
        return
            ()
    case element(tei:history)
        return
            ()
    
    case element(tei:bindingDesc)
        return
            ()
    
    case element(tei:decoDesc)
        return
            ()
    case element(tei:collation)
        return
            ()
    case element(tei:foliation)
        return
            ()
    
    case element(tei:summary)
        return
            ()
    case element(tei:binding)
        return
            ()
    case element(tei:q)
        return
            if ($node/text()) then
                <fo:block
                    padding="5mm"
                    id="{generate-id($node)}"
                    font-style="italic">
                    {
                        if ($node/@xml:lang) then
                            fo:lang($node/@xml:lang)
                        else
                            ()
                    }
                    {fo:tei2fo($node/node())}
                </fo:block>
            else
                let $nl := string($node/@xml:lang)
                let $languages := root($node)//tei:langUsage
                let $matchLang := $languages/tei:language[@ident = $nl]
                return
                    <fo:block>Text in {$matchLang/text()}</fo:block>
    
    case element(tei:place)
        return
            <fo:block
            >({
                    for $pn in $node/tei:placeName
                    return
                        (<fo:inline>{$pn/text()}</fo:inline>,
                        <fo:inline
                            vertical-align="super"
                            font-size="8pt">{string($pn/@xml:lang)}</fo:inline>,
                        <fo:inline>
                        </fo:inline>)
                }; {<fo:inline>{replace(coord:getCoords(string(root($node)/tei:TEI/@xml:id)), ',', ' ')}</fo:inline>})
                {fo:tei2fo($node/node()[not(name() = 'listBibl')][not(name() = 'placeName')][not(name() = 'location')])}
            </fo:block>
    case element(tei:person)
        return
            if (root($node)/tei:TEI/@type = 'pers') then
                <fo:block
                >( {
                        for $pn in $node/tei:persName
                        return
                            (<fo:inline>{$pn/text()}</fo:inline>,
                            <fo:inline
                                vertical-align="super"
                                font-size="8pt">{string($pn/@xml:lang)}
                            </fo:inline>)
                    } )
                    {fo:tei2fo($node/node()[not(name() = 'persName')])}
                </fo:block>
            else
                fo:tei2fo($node/node())
                (:case element(tei:list)
        return
            <fo:list-block
                provisional-label-separation="1em"
                provisional-distance-between-starts="4em"
            >
                {fo:tei2fo($node/node())}
            </fo:list-block>
            
             case element(tei:item)
        return
            <fo:list-item>
                <fo:list-item-label
                    end-indent="label-end()">
                    <fo:block> - </fo:block>
                </fo:list-item-label>
                <fo:list-item-body
                    start-indent="body-start()">
                    <fo:block>{fo:tei2fo($node/node())}</fo:block>
                </fo:list-item-body>
            </fo:list-item>:)
    
    case element(tei:listWit)
        return
            <fo:block
            >
                {fo:tei2fo($node/node())}
            </fo:block>
    
    case element(tei:witness)
        return
            
            <fo:block>{string($node/@xml:id)}: {titles:printTitleMainID(string($node/@corresp))}</fo:block>
    
    
    case element(tei:titleStmt)
        return
            ()
    case element(tei:date)
        return
            if ($node/@notBefore and $node/@notAfter) then
                <fo:inline>{string($node/@notBefore) || '-' || string($node/@notAfter)}</fo:inline>
            else
                if ($node/@when) then
                    <fo:inline>{string($node/@when)}</fo:inline>
                else
                    if ($node/@type = 'foundation')
                    then
                        <fo:inline>(Foundation: {$node/text()})</fo:inline>
                    else
                        $node/text()
    
    case element(tei:origDate)
        return
            (if ($node/text()) then
                <fo:inline>{$node/text()}</fo:inline>
            else
                (),
            if ($node/@notBefore and $node/@notAfter) then
                <fo:inline>{string($node/@notBefore) || '-' || string($node/@notAfter)}</fo:inline>
            else
                if ($node/@when) then
                    <fo:inline>{string($node/@when)}</fo:inline>
                
                else
                    (),
            if ($node/@evidence) then
                <fo:inline>{string($node/@evidence)}</fo:inline>
            else
                ()
            )
    case element(tei:additions)
        return
            ()
    case element(tei:publicationStmt)
        return
            ()
    case element(tei:msIdentifier)
        return
            ()
    
    case element(tei:label)
        return
            <fo:block>{$node/text()}</fo:block>
    
    case element(tei:l)
        return
            
            (
            <fo:inline
                vertical-align="super"
                font-size="8pt">{
                    if ($node/tei:ref) then
                        <fo:basic-link
                            external-destination="{string($node/tei:ref/@target)}">{string($node/@n)}</fo:basic-link>
                    else
                        string($node/@n)
                }</fo:inline>,
            $node/text()
            )
    
    case element(tei:listBibl)
        return
            <fo:block>
                <fo:block>{functx:capitalize-first(string($node/@type))} Bibliography</fo:block>
                {fo:tei2fo($node/node())}
            </fo:block>
    
    case element(tei:bibl)
        return
            if ($node/node()) then
                fo:Zotero($node/tei:ptr/@target)
            else
                ()
    
    case element(tei:div)
        return
            if ($node/@type = 'edition') then
                <fo:block>{
                        if ($node/@xml:lang) then
                            fo:lang($node/@xml:lang)
                        else
                            ()
                    }{fo:tei2fo($node/node())}</fo:block>
            else
                if ($node/@type = 'textpart') then
                    
                    (<fo:block
                        space-before="3mm">
                        <fo:inline>
                            {
                                if ($node/tei:ab/tei:title/tei:ref)
                                then
                                    <fo:basic-link
                                        external-destination="{$node/tei:ab/tei:title/tei:ref/@target}">{$node/tei:label/text()}</fo:basic-link>
                                else
                                    string-join($node/tei:ab/tei:title/text(), '')
                            }</fo:inline></fo:block>,
                    <fo:block
                        space-before="3mm">{fo:tei2fo($node/node()[not(name() = 'label')])}</fo:block>)
                else
                    if ($node/@type = 'bibliography') then
                        fo:tei2fo($node/node())
                    else
                        ()
    case element(tei:ab)
        return
            if ($node/@type = 'foundation') then
                (<fo:block
                    font-size="1.2em"
                    space-before="2mm"
                    space-after="3mm">{functx:capitalize-first(string($node/@type))}</fo:block>,
                <fo:block>{fo:tei2fo($node/node())}</fo:block>)
            
            else
                if ($node/@type = 'history') then
                    <fo:block>{fo:tei2fo($node/node())}</fo:block>
                else
                    fo:tei2fo($node/node()[not(name() = 'title')])
    
    case element(tei:desc)
        return
            fo:tei2fo($node/node())
    
    case element(tei:locus)
        return
            <fo:inline>{
                    '(' || (
                    if ($node/@from and $node/@to)
                    then
                        ('ff.' || string($node/@from) || '-' || string($node/@to))
                    else
                        if ($node/@from) then
                            ('ff.' || string($node/@from || ' and following'))
                        else
                            if ($node/@target) then
                                let $targets := if (contains($node/@target, ' ')) then
                                    for $t in tokenize($node/@target, ' ')
                                    return
                                        ('f. ' || substring-after($t, '#'))
                                else
                                    ('f. ' || substring-after(string($node/@target), '#'))
                                
                                return
                                    string-join($targets, ', ')
                            else
                                $node/text()
                    ) || ')'
                }</fo:inline>
    
    
    case element(tei:notatedMusic)
        return
            <fo:block>
                <fo:inline
                    font-weight="bold"
                    font-family="Ludolfus">{functx:capitalize-first(string($node/name()))}: </fo:inline>
                {fo:tei2fo($node/node())}
            </fo:block>
    case element(tei:msContents)
        return
            (<fo:block
                start-indent="1em"
                end-indent="1em"
                font-size="1.5em"
                space-before="2mm"
                space-after="3mm">Contents</fo:block>,
            <fo:block>
                {fo:tei2fo($node/node())}
            </fo:block>)
    
    case element(tei:msItem)
        return
            <fo:block
                id="{generate-id($node)}"
                font-family="Ludolfus"
                space-after="2mm">
                {
                    if ($node/parent::tei:msItem) then
                        attribute start-indent {'10mm'}
                    else
                        ()
                }
                <fo:inline
                    font-weight="bold">{string($node/@xml:id)}: {fo:tei2fo($node/tei:title)}</fo:inline>
                {fo:tei2fo($node/node()[not(name() = 'title')])}
            </fo:block>
    
    case element(tei:incipit)
        return
            <fo:block
                margin-left="5mm"
                id="{generate-id($node)}"
                font-style="italic">
                {
                    if ($node/@xml:lang) then
                        if ($node/@xml:lang) then
                            fo:lang($node/@xml:lang)
                        else
                            ()
                    else
                        ()
                }
                <fo:inline
                    font-weight="bold"
                    font-family="Ludolfus">{functx:capitalize-first(string($node/name()))}: </fo:inline>
                {fo:tei2fo($node/node())}
            </fo:block>
    
    case element(tei:explicit)
        return
            <fo:block
                margin-left="5mm"
                id="{generate-id($node)}"
                font-style="italic">
                {
                    if ($node/@xml:lang) then
                        fo:lang($node/@xml:lang)
                    else
                        ()
                }
                <fo:inline
                    font-weight="bold"
                    font-family="Ludolfus">{functx:capitalize-first(string($node/name()))}: </fo:inline>
                {fo:tei2fo($node/node())}
            </fo:block>
    case element(tei:colophon)
        return
            <fo:block
                margin-left="5mm"
                id="{generate-id($node)}"
                font-style="italic">
                {
                    if ($node/@xml:lang) then
                        fo:lang($node/@xml:lang)
                    else
                        ()
                }
                <fo:inline
                    font-weight="bold"
                    font-family="Ludolfus">{functx:capitalize-first(string($node/name()))}: </fo:inline>
                {fo:tei2fo($node/node())}
            </fo:block>
    case element(tei:title)
        return
            fo:entitiesWithRef($node)
    
    case element(tei:placeName)
        return
            fo:entitiesWithRef($node)
    
    case element(tei:ref)
        return
            fo:entitiesWithRef($node)
    
    
    case element(tei:persName)
        return
            fo:entitiesWithRef($node)
    
    case element(tei:measure)
        return
            <fo:inline>
                {$node/text()}
                {
                    if ($node/@type) then
                        (' ' || string($node/@type))
                    else
                        ()
                }
                {
                    if ($node/@unit) then
                        (' ' || string($node/@unit))
                    else
                        ()
                }
            
            </fo:inline>
    
    case element(tei:foreign)
        return
            <fo:inline>
                {
                    if ($node/@xml:lang) then
                        fo:lang($node/@xml:lang)
                    else
                        ()
                }
                {$node//text()}
            </fo:inline>
    
    case element()
        return
            fo:tei2fo($node/node())
    default
        return
            $node
};

declare function fo:citation($title, $doc, $id) {
    let $collection := app:switchcol($doc/tei:TEI/@type)
    let $bibdata := <bibl>
        {
            for $author in distinct-values($doc//tei:revisionDesc/tei:change/@who)
            return
                <author>{app:editorKey(string($author))}</author>
        }
        <title
            level="a">{$title}</title>
        <title
            level="j">{$doc//tei:publisher/text()}</title>
        <date
            type="accessed"> [Accessed: {current-date()}] </date>
        {
            let $time := max($doc//tei:revisionDesc/tei:change/xs:date(@when))
            return
                <date
                    type="lastModified">(Last Modified: {format-date($time, '[D].[M].[Y]')}) </date>
        }
        <idno
            type="url">
            {($config:appUrl || '/' || $collection || '/' || $id)}
        </idno>
    </bibl>
    return
        
        
        <fo:block
            
            margin-right="2mm"
            margin-left="2mm"
            margin-top="1mm"
            font-family="Ludolfus">{
                for $a in $bibdata//author/text()
                return
                    ($a || ', ')
            } ʻ{$bibdata//title[@level = 'a']/text()}ʼ, in Alessandro Bausi, ed.,
            <fo:inline
                font-style="italic">{($bibdata//title[@level = 'j']/text() || ' ')}</fo:inline>
            {$bibdata//date[@type = 'lastModified']/text()}
            <fo:basic-link
                external-destination="{$bibdata/idno/text()}">{$bibdata/idno/text()}</fo:basic-link>
            {$bibdata//date[@type = 'accessed']/text()}
        </fo:block>
        
        
        (:<h3>Attributions of the contents</h3>
                <div>
                    {
                        for $respStmt in $document//tei:titleStmt/tei:respStmt
                        let $action := $respStmt/tei:resp
                        let $authors :=
                        for $p in $respStmt/tei:persName
                        return
                            (if ($p/@ref) then
                                app:editorKey(string($p/@ref))
                            else
                                $p) || (if ($p/@from or $p/@to) then
                                (' (' || 'from ' || $p/@from || ' to ' || $p/@to || ')')
                            else
                                ())
                        
                        
                        order by $action descending
                        return
                            <p>
                                {($action || ' by ' || string-join($authors, ', '))}
                            </p>
                    }
                
                </div>
            </div>:)

};

declare function fo:revisions($revisionDesc as element(tei:revisionDesc)) {
    
    <fo:list-block
        provisional-label-separation="1em"
        provisional-distance-between-starts="4em">
        {
            for $change in $revisionDesc/tei:change
            let $time := $change/@when
            let $author := app:editorKey(string($change/@who))
            order by $time descending
            return
                <fo:list-item>
                    <fo:list-item-label
                        end-indent="label-end()"><fo:block>- </fo:block></fo:list-item-label>
                    <fo:list-item-body
                        start-indent="body-start()">
                        <fo:block>
                            {$author || ' '}
                            <fo:inline
                                font-style="italic">
                                {$change/text()}
                            </fo:inline>
                            {' on ' || format-date($time, '[D].[M].[Y]')}
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
        }
    
    </fo:list-block>
};

declare function fo:titlepage($file, $titleStmt as element(tei:titleStmt), $pubStmt as element(tei:publicationStmt), $title as xs:string, $id) {
    <fo:page-sequence
        master-reference="BM">
        <fo:flow
            flow-name="xsl-region-body"
            font-family="Ludolfus">
            <fo:block
                font-size="44pt"
                text-align="center">
                {
                    $title
                }
            </fo:block>
            <fo:block
                text-align="center"
                font-size="20pt"
                font-style="italic"
                space-before="2em"
                space-after="2em">
                edited by
            </fo:block>
            <fo:block
                text-align="center"
                font-size="20pt"
                font-style="italic"
                space-before="2em"
                space-after="2em">
                {
                    let $auts := for $author in $titleStmt//tei:editor[not(@role)]
                    order by $author/@key
                    return
                        app:editorKey($author/@key)
                    return
                        if (count($auts) eq 2) then
                            string-join($auts, ' and ')
                        else
                            if (count($auts) gt 2) then
                                string-join($auts[not(position() = last())], ', ') || ' and ' || $auts[position() = last()]
                            else
                                $auts
                }
            </fo:block>
            <fo:block
                text-align="center"
                font-size="20pt"
                font-style="italic"
                space-before="2em"
                space-after="2em">
                {fo:tei2fo(root($pubStmt)//tei:editionStmt)
                }
            </fo:block>
            <fo:block
                text-align="center"
                font-size="14pt"
                space-before="2em"
                space-after="2em">
                <fo:basic-link
                    external-destination="{$pubStmt//tei:availability/tei:licence/@target}">{$pubStmt//tei:availability/tei:licence/text()}</fo:basic-link>
            </fo:block>
            <fo:block
                text-align="center"
                font-size="12pt"
                space-before="2em"
                space-after="2em">
                {$titleStmt//tei:funder/text()}
            </fo:block>
            <fo:block
                text-align="center"
                font-size="12pt"
                space-before="2em"
                space-after="2em">
                {($pubStmt//tei:authority/text() || ', ' || $pubStmt//tei:publisher/text() || ', ' || $pubStmt//tei:pubPlace/text())}
            </fo:block>
            <fo:block
                background-color="#EEEEEE"
                font-size="12pt"
            >
                {fo:citation($title, $file, $id)}
            </fo:block>
        </fo:flow>
    </fo:page-sequence>
};

declare function fo:table-of-contents($work as element(tei:TEI)) {
    <fo:page-sequence
        master-reference="BM">
        <fo:flow
            flow-name="xsl-region-body"
            font-family="Ludolfus">
            <fo:block
                font-size="30pt"
                space-after="1em"
                font-family="Ludolfus">Table of Contents</fo:block>
            {
                if ($work//tei:msPart) then
                    for $part at $p in $work//tei:msPart
                    return
                        <fo:block
                            text-align-last="justify"
                            margin-left="4mm"
                            margin-top="2mm">
                            Codicological Unit {substring-after($part/@xml:id, 'p')}
                            <fo:leader
                                leader-pattern="dots"/>
                            <fo:page-number-citation
                                ref-id="{generate-id($part)}"/>
                            {
                                for $item at $pitem in $part//tei:msItem
                                return
                                    <fo:block
                                        text-align-last="justify"
                                        margin-left="4mm"
                                        margin-top="2mm">
                                        {
                                            fo:tei2fo($item/tei:title)
                                        }
                                        <fo:leader
                                            leader-pattern="dots"/>
                                        <fo:page-number-citation
                                            ref-id="{generate-id($item)}"/>
                                    </fo:block>
                            }
                        </fo:block>
                else
                    for $item at $pitem in $work//tei:msItem
                    return
                        <fo:block
                            text-align-last="justify"
                            margin-left="4mm"
                            margin-top="2mm">
                            {
                                fo:tei2fo($item/tei:title)
                            }
                            <fo:leader
                                leader-pattern="dots"/>
                            <fo:page-number-citation
                                ref-id="{generate-id($item)}"/>
                        </fo:block>
            }
        
        </fo:flow>
    </fo:page-sequence>
};

declare function fo:bookmarks($work as element(tei:TEI)) {
    <fo:bookmark-tree>
        {
            if ($work//tei:msPart) then
                for $part at $p in $work//tei:msPart
                return
                    <fo:bookmark
                        internal-destination="{generate-id($part)}">
                        <fo:bookmark-title
                            font-weight="bold">Codicological Unit {substring-after($part/@xml:id, 'p')}</fo:bookmark-title>
                        {
                            for $item at $pitem in $part//tei:msItem
                            return
                                <fo:bookmark
                                    internal-destination="{generate-id($item)}">
                                    <fo:bookmark-title
                                        font-weight="bold">{replace(substring-after(string($item/@xml:id), 'p'), '_', ' ')}</fo:bookmark-title>
                                </fo:bookmark>
                        
                        }
                    </fo:bookmark>
            else
                for $item at $pitem in $work//tei:msItem
                return
                    <fo:bookmark
                        internal-destination="{generate-id($item)}">
                        <fo:bookmark-title
                            font-weight="bold">{replace(substring-after(string($item/@xml:id), 'p'), '_', ' ')}</fo:bookmark-title>
                    </fo:bookmark>
        }
    
    </fo:bookmark-tree>
};


declare function fo:additions($additions as element(tei:additions)) {
    <fo:list-block
        provisional-label-separation="1em"
        provisional-distance-between-starts="4em"
        id="{generate-id($additions)}">
        
        {
            for $addition in $additions//tei:item
            return
                <fo:list-item
                    margin-bottom="2mm">
                    <fo:list-item-label
                        end-indent="label-end()">
                        <fo:block>{string($addition/@xml:id)}</fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body
                        start-indent="body-start()">
                        <fo:block>{
                                if ($addition/tei:desc/@type) then
                                    <fo:inline
                                        font-weight="bold">{titles:printTitleMainID(string($addition/tei:desc/@type))}</fo:inline>
                                else
                                    ()
                            }{fo:tei2fo($addition/node())}</fo:block>
                    </fo:list-item-body>
                </fo:list-item>
        
        }
    
    </fo:list-block>
};

declare function fo:collation($collation as element(tei:collation)) {
    <fo:list-block
        provisional-label-separation="1em"
        provisional-distance-between-starts="4em"
        id="{generate-id($collation)}">
        
        {
            for $quire in $collation//tei:item
            return
                <fo:list-item
                    margin-bottom="2mm">
                    <fo:list-item-label
                        end-indent="label-end()">
                        <fo:block>{if($quire/@n) then string($quire/@n) else string($quire/@xml:id)}</fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body
                        start-indent="body-start()">
                        <fo:block>{($quire/tei:dim/text() || ' leaves, ')}{fo:tei2fo($quire/node()[not(name()='dim')])}</fo:block>
                    </fo:list-item-body>
                </fo:list-item>
        
        }
    
    </fo:list-block>
};

declare function fo:paleo($handDesc as element(tei:handDesc)) {
    <fo:block-container>
        <fo:table
            id="{generate-id($handDesc)}"
            inline-progression-dimension="auto"
            space-after="1em">
            <fo:table-column
                column-width="30%"/>
            <fo:table-column
                column-width="70%"/>
            
            <fo:table-body>
                {
                    for $handnote in $handDesc/tei:handNote
                    return
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">{'Hand ' || string($handnote/@xml:id) || ' (' || string($handnote/@script) || ')'}</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{
                                        if ($handnote/node()) then
                                            fo:tei2fo($handnote/node())
                                        else
                                            ()
                                    }</fo:block></fo:table-cell>
                        
                        
                        </fo:table-row>
                }
            </fo:table-body>
        </fo:table>
    </fo:block-container>
};

declare function fo:physic($physDesc as element(tei:physDesc)) {
    <fo:block-container>
        <fo:table
            id="{generate-id($physDesc)}"
            inline-progression-dimension="auto"
            space-after="1em">
            <fo:table-column
                column-width="30%"/>
            <fo:table-column
                column-width="70%"/>
            <fo:table-body>
                {
                    if ($physDesc//tei:support//tei:material/@key and $physDesc//tei:objectDesc/@form) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Form of support</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{(functx:capitalize-first(string($physDesc//tei:support//tei:material/@key)) || ' ' || string($physDesc//tei:objectDesc/@form))}</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($physDesc//tei:extent/tei:measure) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Extent</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{fo:tei2fo($physDesc//tei:extent)}</fo:block></fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($physDesc//tei:extent/tei:dimensions[@type = 'outer']/node()) then
                        <fo:table-row
                            height="25pt"><fo:table-cell><fo:block
                                    font-weight="bold">Outer Dimension</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{
                                        for $dim in $physDesc//tei:extent/tei:dimensions[@type = 'outer']/element()
                                        return
                                            <fo:inline>{(functx:capitalize-first(string($dim/name())) || ' ' || $dim/text() || string($physDesc//tei:dimensions[@type = 'outer']/@unit) || ' ')}</fo:inline>
                                    }</fo:block></fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($physDesc//tei:bindingDesc/node()) then
                        (<fo:table-row
                            height="25pt"><fo:table-cell><fo:block
                                    font-weight="bold">Binding</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{
                                        if ($physDesc//tei:binding/@contemporary) then
                                            string($physDesc//tei:binding/@contemporary)
                                        else
                                            ()
                                    }</fo:block></fo:table-cell>
                        
                        </fo:table-row>,
                        for $bN in $physDesc//tei:bindingDesc/tei:binding/tei:decoNote
                        return
                            <fo:table-row
                                height="25pt"><fo:table-cell><fo:block
                                        font-weight="bold">{
                                            if ($bN/tei:material) then
                                                'Material'
                                            else
                                                if ($bN/@type) then
                                                    functx:capitalize-first(string($bN/@type))
                                                else
                                                    if ($bN/@xml:id) then
                                                        string($bN/@xml:id)
                                                    else
                                                        ()
                                        }</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>{
                                            if ($bN/tei:material) then
                                                let $materials := for $m in $bN/tei:material/@key
                                                return
                                                    string($m)
                                                return
                                                    string-join($materials, ', ')
                                            else
                                                if ($bN/@*) then
                                                    fo:tei2fo($bN/node())
                                                else
                                                    ()
                                        }</fo:block></fo:table-cell>
                            
                            </fo:table-row>
                        )
                    else
                        ()
                }
                {
                    if ($physDesc//tei:layoutDesc/tei:layout/node()) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Layout</fo:block></fo:table-cell>
                            <fo:table-cell>
                                <fo:block>{
                                        for $l in $physDesc//tei:layoutDesc/tei:layout
                                        return
                                            <fo:block>{'Columns: ' || (if($l/@columns) then $l/@columns else 'n/a') || ', Written lines: ' || (if($l/@writtenLines) then $l/@writtenLines else 'n/a')}</fo:block>
                                    }</fo:block>
                            </fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($physDesc//tei:collation/node()) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Collation</fo:block></fo:table-cell>
                            <fo:table-cell>
                                <fo:block>{fo:collation($physDesc//tei:collation)}</fo:block>
                            </fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($physDesc//tei:condition/node()) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Condition</fo:block></fo:table-cell>
                            <fo:table-cell>
                                <fo:block>{functx:capitalize-first(string($physDesc//tei:condition/@key))}: {fo:tei2fo($physDesc//tei:condition/node())}</fo:block>
                            </fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if (root($physDesc)//tei:custEvent/node()) then
                    let $ce := root($physDesc)//tei:custEvent
                    return
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Restoration</fo:block></fo:table-cell>
                            <fo:table-cell>
                                <fo:block>{functx:capitalize-first(string($ce/@type))}, {string($ce/@subtype)}</fo:block>
                            </fo:table-cell>
                        
                        </fo:table-row>
                    else
                        ()
                }
            </fo:table-body>
        </fo:table>
    </fo:block-container>
};

declare function fo:codic($msPart) {
    let $msID := $msPart/tei:msIdentifier
    let $origDate := $msPart/tei:history/tei:origin/tei:origDate
    return
        <fo:table
            id="{generate-id($msID)}"
            inline-progression-dimension="auto"
            space-after="1em">
            <fo:table-column
                column-width="30%"/>
            <fo:table-column
                column-width="70%"/>
            
            <fo:table-body>
                {
                    if ($msID/tei:idno/text()) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Identifier</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{$msID/tei:idno/text()}</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($msID/tei:altIdentifier/text()) then
                        for $altID in $msID/tei:altIdentifier
                        return
                            <fo:table-row
                                height="25pt">
                                <fo:table-cell><fo:block
                                        font-weight="bold">Alternative Identifier</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>{$altID/tei:idno/text()}</fo:block></fo:table-cell>
                            </fo:table-row>
                    else
                        ()
                }
                {
                    if ($msID/tei:collection/text()) then
                        for $collection in $msID/tei:collection
                        return
                            <fo:table-row
                                height="25pt">
                                <fo:table-cell><fo:block
                                        font-weight="bold">Collection</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>{$collection/text()}</fo:block></fo:table-cell>
                            </fo:table-row>
                    else
                        ()
                }
                {
                    if ($msID/tei:repository/@ref) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Repository</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{fo:entitiesWithRef($msID/tei:repository)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($origDate) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Date</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{fo:tei2fo($origDate)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if (root($msPart)//tei:persName[@role]) then
                        for $person in ($msPart//tei:persName[@role], root($msPart)//tei:particDesc//tei:persName[@role])
                        return
                            <fo:table-row
                                height="25pt">
                                <fo:table-cell><fo:block
                                        font-weight="bold">{functx:capitalize-first(string($person/@role))}</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>{fo:entitiesWithRef($person)}</fo:block></fo:table-cell>
                            </fo:table-row>
                    else
                        ()
                }
                {
                    if (root($msPart)//tei:term) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Keywords</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>
                                    {
                                        let $terms := for $k in root($msPart)//tei:term
                                        return
                                            <fo:inline>
                                                <fo:basic-link
                                                    external-destination="{
                                                            $config:appUrl || '/authority-files/list?keyword=' ||
                                                            string($k/@key)
                                                        }">↗{titles:printTitleMainID($k/@key)}</fo:basic-link>
                                            </fo:inline>
                                        return
                                            $terms
                                    }</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
                {
                    if ($msPart//tei:source/tei:listBibl[@type = 'catalogue']) then
                        <fo:table-row
                            height="25pt">
                            <fo:table-cell><fo:block
                                    font-weight="bold">Catalogue</fo:block></fo:table-cell>
                            <fo:table-cell><fo:block>{
                                        for $catalogue in $msPart//tei:source/tei:listBibl[@type = 'catalogue']/tei:bibl
                                        return
                                            (fo:Zotero($catalogue/tei:ptr/@target),
                                            if ($catalogue/tei:citedRange) then
                                                let $crs := for $cR in $catalogue/tei:citedRange
                                                return
                                                    (if ($cR/@unit) then
                                                        string($cR/@unit)
                                                    else
                                                        () || ' ' || $cR/text())
                                                return
                                                    string-join($crs, ', ')
                                            else
                                                ()
                                            )
                                    
                                    }</fo:block></fo:table-cell>
                        </fo:table-row>
                    else
                        ()
                }
            </fo:table-body>
        </fo:table>
};

declare function fo:main($id as xs:string) {
    let $title := titles:printTitleMainID($id)
    let $file := root(collection($config:data-root)//id($id))//tei:TEI
    let $ty := string($file/@type)
    return
        <fo:root
            xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:page-sequence-master
                    master-name="chapter-master">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference
                            page-position="first"
                            odd-or-even="odd"
                            master-reference="chapter-first-odd"/>
                        <fo:conditional-page-master-reference
                            page-position="first"
                            odd-or-even="even"
                            master-reference="chapter-first-even"/>
                        <fo:conditional-page-master-reference
                            page-position="rest"
                            odd-or-even="odd"
                            master-reference="chapter-rest-odd"/>
                        <fo:conditional-page-master-reference
                            page-position="rest"
                            odd-or-even="even"
                            master-reference="chapter-rest-even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
                <fo:page-sequence-master
                    master-name="EAe-master">
                    <fo:repeatable-page-master-alternatives>
                        
                        <fo:conditional-page-master-reference
                            page-position="any"
                            odd-or-even="odd"
                            master-reference="encyclo-odd"/>
                        <fo:conditional-page-master-reference
                            page-position="any"
                            odd-or-even="even"
                            master-reference="encyclo-even"/>
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>
                <fo:simple-page-master
                    master-name="encyclo-odd"
                    margin-top="10mm"
                    margin-bottom="10mm"
                    margin-left="12mm"
                    margin-right="12mm">
                    <fo:region-body
                        column-count="2"
                        column-gap="10mm"
                        margin-top="20mm"
                        margin-left="0mm"
                        margin-right="0mm"
                        margin-bottom="20mm"/>
                    <fo:region-before
                        extent="50pt"
                        region-name="rest-region-before-even"/>
                    <fo:region-after
                        extent="20mm"/>
                </fo:simple-page-master>
                <fo:simple-page-master
                    master-name="encyclo-even"
                    margin-top="10mm"
                    margin-bottom="10mm"
                    margin-left="12mm"
                    margin-right="12mm">
                    <fo:region-body
                        column-count="2"
                        column-gap="10mm"
                        margin-top="20mm"
                        margin-left="0mm"
                        margin-right="0mm"
                        margin-bottom="20mm"/>
                    <fo:region-before
                        extent="50pt"
                        region-name="rest-region-before-odd"/>
                    <fo:region-after
                        extent="20mm"/>
                </fo:simple-page-master>
                <fo:simple-page-master
                    master-name="BM"
                    margin-top="20mm"
                    margin-bottom="20mm"
                    margin-left="20mm"
                    margin-right="20mm">
                    <fo:region-body
                        margin-top="20mm"
                        margin-left="0mm"
                        margin-right="0mm"
                        margin-bottom="20mm"/>
                    <fo:region-before
                        extent="20mm"/>
                    <fo:region-after
                        extent="20mm"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master
                    master-name="chapter-first-odd"
                    margin-top="75pt"
                    margin-bottom="50pt"
                    margin-left="75pt"
                    margin-right="50pt">
                    <fo:region-body
                        margin-bottom="40pt"/>
                    <fo:region-after
                        extent="25pt"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master
                    master-name="chapter-first-even"
                    margin-top="75pt"
                    margin-bottom="50pt"
                    margin-left="50pt"
                    margin-right="75pt">
                    <fo:region-body
                        margin-bottom="40pt"/>
                    <fo:region-after
                        extent="25pt"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master
                    master-name="chapter-rest-odd"
                    margin-top="25pt"
                    margin-bottom="50pt"
                    margin-left="75pt"
                    margin-right="50pt">
                    <fo:region-body
                        margin-top="50pt"
                        margin-bottom="40pt"/>
                    <fo:region-before
                        extent="50pt"
                        region-name="rest-region-before-odd"/>
                    <fo:region-after
                        extent="25pt"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master
                    master-name="chapter-rest-even"
                    margin-top="25pt"
                    margin-bottom="50pt"
                    margin-left="50pt"
                    margin-right="75pt">
                    <fo:region-body
                        margin-top="50pt"
                        margin-bottom="40pt"/>
                    <fo:region-before
                        extent="50pt"
                        region-name="rest-region-before-even"/>
                    <fo:region-after
                        extent="25pt"/>
                </fo:simple-page-master>
            
            </fo:layout-master-set>
            {
                if ($ty = 'mss') then
                    fo:bookmarks($file)
                else
                    ()
            }
            {fo:titlepage($file, $file//tei:titleStmt, $file//tei:publicationStmt, $title, $id)}
            {
                if ($ty = 'mss') then
                    fo:table-of-contents($file)
                else
                    ()
            }
            
            <fo:page-sequence
            >
                {
                    switch ($ty)
                        case 'place'
                            return
                                attribute master-reference {"EAe-master"}
                        case 'pers'
                            return
                                attribute master-reference {"EAe-master"}
                        case 'ins'
                            return
                                attribute master-reference {"EAe-master"}
                        default return
                            attribute master-reference {"chapter-master"}
            }
            <fo:static-content
                flow-name="rest-region-before-odd">
                <fo:block-container
                    height="100%"
                    display-align="center"
                    text-align="end">
                    <fo:block
                        font-family="Ludolfus"
                        font-size="0.8em"
                    > Beta maṣāḥǝft - <fo:page-number/></fo:block>
                </fo:block-container>
                <fo:block>
                    <fo:leader
                        space-after="12pt"/>
                </fo:block>
            </fo:static-content>
            <fo:static-content
                flow-name="rest-region-before-even">
                <fo:block-container
                    height="100%"
                    display-align="center"
                    text-align="start">
                    <fo:block
                        font-family="Ludolfus"
                        font-size="0.8em"
                    >
                        <fo:page-number/> - {$title}</fo:block>
                </fo:block-container>
                <fo:block>
                    <fo:leader
                        space-after="12pt"/>
                </fo:block>
            </fo:static-content>
            <fo:static-content
                flow-name="xsl-region-after">
                <fo:block-container>
                    <fo:block
                        font-size="0.7em"
                        space-before="10mm"
                        font-family="Ludolfus">
                        <fo:basic-link
                            external-destination="{$config:appUrl}/{$id}/main"><fo:inline
                                font-family="Ludolfus">Beta maṣāḥǝft, </fo:inline>
                            {$title} | PDF generated form the app on {current-dateTime()}
                        </fo:basic-link>.
                        <fo:block
                            font-family="Ludolfus">To cite this resource please import embedded metadata from the web page to your reference system or use the following:</fo:block>
                        {fo:citation($title, $file, $id)}
                    </fo:block>
                </fo:block-container>
            </fo:static-content>
            <fo:static-content
                flow-name="xsl-footnote-separator">
                <fo:block></fo:block>
            </fo:static-content>
            <fo:flow
                flow-name="xsl-region-body"
                font-family="Ludolfus"
                text-align="justify">
                {
                    switch ($ty)
                        case 'place'
                            return
                                (<fo:block>{fo:tei2fo($file//tei:place)}</fo:block>,
                                <fo:block>{fo:tei2fo($file//tei:listBibl/node())}</fo:block>)
                        case 'pers'
                            return
                                (<fo:block>{fo:tei2fo($file//tei:person/node())}</fo:block>,
                                <fo:block>{fo:tei2fo($file//tei:div[@type = 'bibliography']/node())}</fo:block>)
                        case 'work'
                            return
                                (if ($file//tei:listWit) then
                                    <fo:block>
                                        
                                        <fo:block
                                            space-before="4mm"
                                            start-indent="1em"
                                            end-indent="1em"
                                            font-size="1.5em"
                                            space-after="3mm">Witnesses</fo:block>
                                        
                                        <fo:block>
                                            {fo:tei2fo($file//tei:listWit/node())}</fo:block>
                                    </fo:block>
                                else
                                    (),
                                if ($file//tei:text) then
                                    <fo:block>
                                        
                                        <fo:block
                                            space-before="4mm"
                                            start-indent="1em"
                                            end-indent="1em"
                                            font-size="1.5em"
                                            space-after="3mm">Text</fo:block>
                                        
                                        <fo:block>
                                            {fo:tei2fo($file//tei:text/node())}</fo:block>
                                    </fo:block>
                                else
                                    ())
                        
                        case 'mss'
                            return
                                
                                if ($file//tei:msPart) then
                                    (
                                    if ($file//tei:msDesc/node()) then
                                        (<fo:block>
                                            <fo:block
                                                start-indent="1em"
                                                end-indent="1em"
                                                font-size="1.5em"
                                                space-before="2mm"
                                                space-after="3mm">General Codicological Information</fo:block>
                                        </fo:block>
                                        ,
                                        if ($file//tei:msDesc/tei:msIdentifier) then
                                            <fo:block>{fo:codic($file//tei:msDesc)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($file//tei:msDesc/tei:physDesc) then
                                            <fo:block>{fo:physic($file//tei:msDesc/tei:physDesc)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($file//tei:msDesc/tei:physDesc/tei:handDesc) then
                                            <fo:block>{fo:paleo($file//tei:msDesc/tei:physDesc/tei:handDesc)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($file//tei:msDesc/tei:msContents) then
                                            <fo:block>{fo:tei2fo($file//tei:msDesc/tei:msContents)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($file//tei:msDesc/tei:additions//tei:list) then
                                            (<fo:block>
                                                <fo:block
                                                    start-indent="1em"
                                                    end-indent="1em"
                                                    font-size="1.2em"
                                                    space-before="2mm"
                                                    space-after="3mm">Additions</fo:block>
                                            </fo:block>,
                                            <fo:block>{fo:additions($file//tei:msDesc//tei:additions)}</fo:block>)
                                        else
                                            ()
                                        )
                                    else
                                        (),
                                    for $mP at $p in $file//tei:msPart
                                    let $uid := substring-after($mP/@xml:id, 'p')
                                    return
                                        (<fo:block>
                                            <fo:block
                                                start-indent="1em"
                                                end-indent="1em"
                                                font-size="1.5em"
                                                space-before="5mm"
                                                space-after="3mm"
                                                id="{generate-id($mP)}">Codicological Information for Unit {$uid}</fo:block>
                                        </fo:block>
                                        ,
                                        if ($mP/tei:msIdentifier/node()) then
                                            <fo:block>{fo:codic($mP//tei:msDesc)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($mP/tei:physDesc/node()) then
                                            <fo:block>{fo:physic($mP//tei:physDesc)}</fo:block>
                                        else
                                            ()
                                        ,
                                        if ($mP/tei:physDesc/tei:handDesc/node()) then
                                            <fo:block>{fo:paleo($mP/tei:physDesc/tei:handDesc)}</fo:block>
                                        else
                                            (),
                                        if ($mP/tei:msContents/node()) then
                                            <fo:block>{fo:tei2fo($mP//tei:msContents)}</fo:block>
                                        else
                                            (),
                                        if ($mP//tei:additions//tei:list/node()) then
                                            (<fo:block>
                                                <fo:block
                                                    start-indent="1em"
                                                    end-indent="1em"
                                                    font-size="1.2em"
                                                    space-before="2mm"
                                                    space-after="3mm">Additions for Unit {$uid}</fo:block>
                                            </fo:block>,
                                            <fo:block>{fo:additions($mP//tei:additions)}</fo:block>)
                                        else
                                            ())
                                    )
                                else
                                    (<fo:block>
                                        <fo:block
                                            start-indent="1em"
                                            end-indent="1em"
                                            font-size="1.5em"
                                            space-before="5mm"
                                            space-after="3mm">Codicological Information</fo:block>
                                    </fo:block>,
                                    if ($file//tei:msDesc/tei:msIdentifier) then
                                        <fo:block>{fo:codic($file//tei:msDesc)}</fo:block>
                                    else
                                        ()
                                    ,
                                    if ($file//tei:msDesc/tei:physDesc) then
                                        <fo:block>{fo:physic($file//tei:physDesc)}</fo:block>
                                    else
                                        ()
                                    ,
                                    if ($file//tei:msDesc/tei:physDesc/tei:handDesc) then
                                        <fo:block>{fo:paleo($file//tei:physDesc/tei:handDesc)}</fo:block>
                                    else
                                        ()
                                    ,
                                    if ($file//tei:msDesc/tei:msContents) then
                                        <fo:block>{fo:tei2fo($file//tei:msContents)}</fo:block>
                                    else
                                        ()
                                    ,
                                    if ($file//tei:additions//tei:list) then
                                        (<fo:block>
                                            <fo:block
                                                start-indent="1em"
                                                end-indent="1em"
                                                font-size="1.2em"
                                                space-before="2mm"
                                                space-after="3mm">Additions</fo:block>
                                        </fo:block>,
                                        <fo:block>{fo:additions($file//tei:additions)}</fo:block>)
                                    else
                                        ()
                                    )
                        
                        default return
                            ()
            }
            
            {
                if ($file//tei:text/tei:div) then
                    <fo:block>
                        
                        <fo:block
                            space-before="4mm"
                            start-indent="1em"
                            end-indent="1em"
                            font-size="1.5em"
                            space-after="3mm">Text</fo:block>
                        
                        <fo:block>
                            {fo:tei2fo($file//tei:text)}</fo:block>
                    </fo:block>
                else
                    ()
            }
            
            <fo:block-container>
                
                <fo:block
                    space-before="4mm"
                    start-indent="1em"
                    end-indent="1em"
                    font-size="1.5em"
                    space-after="3mm">Revisions of the data</fo:block>
                
                {fo:revisions($file//tei:revisionDesc)}
            </fo:block-container>
        
        </fo:flow>
    </fo:page-sequence>

</fo:root>
};



(:fo:main():)
let $id := request:get-parameter("id", ())
let $pdf := xslfo:render(fo:main($id), "application/pdf", (), $local:fop-config)
return
    response:stream-binary($pdf, "media-type=application/pdf", $id || ".pdf")
