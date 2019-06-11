<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:param name="startsection"/>
    <xsl:param name="perpage"/>
    <xsl:variable name="mainID" select="t:TEI/@xml:id"/>
    <xsl:template match="/">
        <div class="w3-container w3-twothird">
            <xsl:if test="//t:body[t:div]">
                <div id="transcription" class="w3-container">
                    <xsl:variable name="numberedDiv" select="//t:div[@type = 'edition']/t:div[@type='textpart'][@n[number(.) &gt;= number($startsection)][number(.) &lt;= number($perpage + ($startsection -1))]]"/>
                    <xsl:choose>
                        <xsl:when test="$numberedDiv">
                            <xsl:apply-templates select="//t:div[@type = 'edition']/t:div[@type='textpart'][@n[number(.) &gt;= number($startsection)][number(.) &lt;= number($perpage + ($startsection -1))]]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="//t:div[@type = 'edition']"/>
                        </xsl:otherwise>
                    </xsl:choose> </div>
                <script type="text/javascript" src="resources/js/pelagios.js"/>
                
                <img id="loadingRole" src="resources/Loading.gif" style="display: none;"/>
                <div id="versions" class="w3-container"/>   
                <div id="translation" class="w3-container w3-large">
                    <h4>Translation</h4>
                    <xsl:variable name="numberedDiv" select="//t:div[@type = 'translation']/t:div[@type='textpart'][@n[number(.) &gt;= number($startsection)][number(.) &lt;= number($perpage + ($startsection -1))]]//t:ab"/>
                    <xsl:choose>
                        <xsl:when test="$numberedDiv">
                            <xsl:apply-templates select="//t:div[@type = 'translation']/t:div[@type='textpart'][@n[number(.) &gt;= number($startsection)][number(.) &lt;= number($perpage + ($startsection -1))]]//t:ab"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="//t:div[@type = 'translation']//t:ab"/>
                        </xsl:otherwise>
                    </xsl:choose> 
                </div>
                <xsl:if test="//t:pb[@facs]">
                    <div id="viewer" class="w3-container"/>
                    <xsl:variable name="iiifMSWitColl" select="concat('/api/iiif/witnesses/', string(t:TEI/@xml:id))"/>
                    <script type="text/javascript">
                        <xsl:text>var data = [{collectionUri: "</xsl:text>
                        <xsl:value-of select="$iiifMSWitColl"/>
                        <xsl:text>"}]</xsl:text>
                    </script>
                    <script type="text/javascript" src="resources/js/editionmirador.js"/>
                </xsl:if>
                <div id="roleAttestations" class="w3-container"/>  
            </xsl:if>
            
        </div>
        <div class="w3-third w3-gray w3-padding">
            
            <xsl:if test="//t:listBibl">
                <div class="col-md-12" id="bibliographyText">
                    <xsl:apply-templates select="//t:listBibl"/>
                </div>
            </xsl:if>
          <!--  <xsl:if test="//t:editionStmt">
                <div class="col-md-12" id="editionStmt">
                    <xsl:apply-templates select="//t:editionStmt"/>
                </div>
            </xsl:if>-->
            <div/>
        </div>
        
        <xsl:call-template name="resp">
            <xsl:with-param name="resp" select="."/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template match="t:relation"/>
    <xsl:include href="resp.xsl"/>
   <xsl:include href="divEdition.xsl"/>
    <xsl:include href="VARIAsmall.xsl"/>
  <xsl:include href="certainty.xsl"/>
    <xsl:include href="locus.xsl"/>
    <xsl:include href="bibl.xsl"/>
    <xsl:include href="ref.xsl"/>
    <xsl:include href="persName.xsl"/>
    <xsl:include href="placeName.xsl"/>
       <xsl:include href="title.xsl"/>
    <xsl:include href="repo.xsl"/>
</xsl:stylesheet>