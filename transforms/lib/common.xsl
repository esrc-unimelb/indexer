<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:n="urn:isbn:1-931666-33-4"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str"
    exclude-result-prefixes="n str"
    version="1.0">

    <!-- Extract the record Id from DC.Identifier -->
    <xsl:template name="record_id">
        <xsl:variable name="filename" select="str:tokenize(//meta[@name='DC.Identifier']/@content, '/')" />
        <xsl:variable name="rid" select="str:tokenize($filename[last()], '.')" />
        <field name="record_id">
            <xsl:value-of select="$rid" />
        </field>
    </xsl:template>

    <!-- Extract the entity functions -->
    <xsl:template match="/n:eac-cpf/n:cpfDescription/n:description/n:functions/n:function/n:term">
        <field name="function"><xsl:value-of select="." /></field>
    </xsl:template>

    <!-- Extract the entity functions -->
    <xsl:template match="/n:eac-cpf/n:cpfDescription/n:description/n:occupations/n:occupation/n:term">
        <field name="function"><xsl:value-of select="." /></field>
    </xsl:template>

    <!-- Extract locality definitions -->
    <xsl:template match="/n:eac-cpf/n:cpfDescription/n:description/n:biogHist/n:chronList/n:chronItem/n:event">
        <field name="locality"><xsl:value-of select="." /></field>
    </xsl:template>

    <!-- Extract the name of the entity -->
    <xsl:template name="name">
        <xsl:variable name="type" select="/n:eac-cpf/n:control/n:localControl[@localType='typeOfEntity']/n:term" />
        <xsl:choose>
            <xsl:when test="$type = 'Person'">
                <field name="name">
                    <xsl:if test="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='familyname']">
                        <xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='familyname']" />
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='givenname']" />
                    </xsl:if>
                    <xsl:if test="not(/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='familyname'])">
                        <xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry[position() = 1]/n:part" />
                    </xsl:if>
                </field>
            </xsl:when>
            <xsl:otherwise>
                <field name="name"><xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry[position() = 1]/n:part" /></field>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Extract the alternate name of the entity -->
    <xsl:template match="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry[position()>1]/n:part">
        <field name="altname"><xsl:value-of select="." /></field>
    </xsl:template>

    <!-- Extract the binomial name of the entity -->
    <xsl:template name="binomial_name">
        <xsl:variable name="type" select="/n:eac-cpf/n:control/n:localControl[@localType='typeOfEntity']/n:term" />
        <xsl:choose>
            <xsl:when test="$type = 'Person'">
                <field name="binomial_name"><xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='honorific title']" /></field>
            </xsl:when>
            <xsl:otherwise>
                <field name="binomial_name"><xsl:value-of select="/n:eac-cpf/n:cpfDescription/n:identity/n:nameEntry/n:part[@localType='parent']" /></field>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Create the display url -->
    <xsl:template name="display_url">
        <field name="display_url">
            <xsl:variable name="path" select="str:split(/n:eac-cpf/n:cpfDescription/n:identity/n:entityId, '/biogs')" />
            <xsl:value-of select="str:replace($path, 'ref', 'guide')" />
            <xsl:text>/</xsl:text>
            <xsl:value-of select="/n:eac-cpf/n:control/n:recordId" />
         </field>
    </xsl:template>
</xsl:stylesheet>