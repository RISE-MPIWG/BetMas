<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/">
        <div id="MainData" class="w3-twothird">      <div id="description">
            <h2>General description</h2>
            <p>
                <xsl:apply-templates select="//t:sourceDesc"/>
            </p>
            <p>
                <xsl:apply-templates select="//t:abstract/t:p"/>
            </p>
            <h2>Bibliography</h2>
            <xsl:apply-templates select="//t:listBibl"/>
            <button class="btn btn-primary" id="showattestations" data-value="term" data-id="{string(t:TEI/@xml:id)}">Show attestations</button>
            <div id="allattestations" class="col-md-12"/>
        </div>
        </div>
    </xsl:template>
    
    <xsl:template match="t:list[ancestor::t:abstract or ancestor::t:desc]">
        <ol>
            <xsl:for-each select="t:item">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ol>
    </xsl:template>
    <!-- elements templates-->
    <xsl:include href="locus.xsl"/>
    <xsl:include href="bibl.xsl"/>
    <xsl:include href="origin.xsl"/>
    <xsl:include href="date.xsl"/>
    <xsl:include href="editorKey.xsl"/>
    <xsl:include href="msselements.xsl"/> 
    
    <!--    elements with references-->
    <xsl:include href="ref.xsl"/>
    <xsl:include href="persName.xsl"/>
    <xsl:include href="placeName.xsl"/>
    <!-- includes also region, country and settlement-->
    <xsl:include href="title.xsl"/>
    <xsl:include href="repo.xsl"/>
</xsl:stylesheet>