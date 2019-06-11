<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/">
        <div id="MainData" class="w3-twothird"> <div id="description">
            <h2>General description</h2>
            <p>
                <xsl:apply-templates select="//t:body/t:p"/>
            </p>
        </div>
        <xsl:if test="//t:listWit">
            <h2>Witnesses</h2>
            <p>This edition is based on the following manuscripts</p>
            <ul>
                <xsl:for-each select="//t:witness">
                    <li>
                        <xsl:apply-templates select="."/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="//t:listBibl">
            <xsl:apply-templates select="//t:listBibl"/>
        </xsl:if>
        </div>
    </xsl:template>
    <!-- elements templates-->
    <xsl:include href="locus.xsl"/>
    <xsl:include href="bibl.xsl"/>
    <xsl:include href="origin.xsl"/>
    <xsl:include href="date.xsl"/>
    <xsl:include href="msselements.xsl"/> <!--includes a series of small templates for elements in manuscript entities-->
    <xsl:include href="witness.xsl"/>    
    
<!--    elements with references-->
    <xsl:include href="ref.xsl"/>
    <xsl:include href="persName.xsl"/>
    <xsl:include href="placeName.xsl"/>
                           <!-- includes also region, country and settlement-->
    <xsl:include href="title.xsl"/>
    <xsl:include href="repo.xsl"/>
                            <!--produces also the javascript for graph-->
</xsl:stylesheet>