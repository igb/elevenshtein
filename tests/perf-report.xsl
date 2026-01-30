<xsl:stylesheet xmlns="http://hccp.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>

  <xsl:param name="testname"/>

  <xsl:template match="node() | @*">
    <xsl:value-of select="$testname"/>
    <xsl:apply-templates select="testsuites"/>
  </xsl:template>

  <xsl:template match="testsuites">
   <xsl:apply-templates  select="testsuite"/>
  </xsl:template>

  <xsl:template match="testsuite">
      <xsl:apply-templates  select="testcase"/>
  </xsl:template>

  
  <xsl:template match="testcase">
    <xsl:if test="@name = $testname">
    <xsl:value-of select="@time"/>, </xsl:if>
  </xsl:template>



</xsl:stylesheet>
