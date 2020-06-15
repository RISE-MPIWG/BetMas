<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dts="https://w3id.org/dts/api#" xmlns:funct="my.funct" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:param name="mainID"/>
<!--    <xsl:param name="translation"/>-->
    <xsl:function name="funct:date">
        <xsl:param name="date"/>
        <xsl:choose>
            <xsl:when test="matches($date, '\d{4}-\d{2}-\d{2}')">
                <xsl:value-of select="format-date(xs:date($date), '[D]-[M]-[Y0001]', 'en', 'AD', ())"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number($date, '####')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="funct:datepicker">
        <xsl:param name="element"/>
        <xsl:choose>
            <xsl:when test="$element/@notBefore or $element/@notAfter">
                <xsl:if test="not($element/@notBefore)">Before </xsl:if>
                <xsl:if test="not($element/@notAfter)">After </xsl:if>
                <xsl:if test="$element/@notBefore">
                    <xsl:value-of select="funct:date($element/@notBefore)"/>
                </xsl:if>
                <xsl:if test="$element/@notBefore and $element/@notAfter">
                    <xsl:text>-</xsl:text>
                </xsl:if>
                <xsl:if test="$element/@notAfter">
                    <xsl:value-of select="funct:date($element/@notAfter)"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="funct:date($element/@when)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$element/@cert">
            <xsl:value-of select="concat(' (certainty: ', $element/@cert, ')')"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="/">
        <div class="w3-container">
                <div id="transcription" class="w3-container">
                                   <xsl:apply-templates/>
                  </div>
                <script type="text/javascript" src="resources/js/pelagios.js"/>
               <img id="loadingRole" src="resources/Loading.gif" style="display: none;"/>
                <div id="versions" class="w3-container"/>   
           <xsl:if test="//t:pb[@facs]">
                    <div id="viewer" class="w3-container"/>
                    <xsl:variable name="iiifMSWitColl" select="concat('/api/iiif/witnesses/', $mainID)"/>
                    <script type="text/javascript">
                        <xsl:text>var data = [{collectionUri: "</xsl:text>
                        <xsl:value-of select="$iiifMSWitColl"/>
                        <xsl:text>"}]</xsl:text>
                    </script>
                    <script type="text/javascript" src="resources/js/editionmirador.js"/>
                </xsl:if>
                <div id="roleAttestations" class="w3-container"/>  
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
    <xsl:include href="ref.xsl"/>
    <xsl:include href="persName.xsl"/>
    <xsl:include href="placeName.xsl"/>
    <xsl:include href="title.xsl"/>
    <xsl:include href="repo.xsl"/>
</xsl:stylesheet>