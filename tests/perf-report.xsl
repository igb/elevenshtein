<xsl:stylesheet xmlns="http://hccp.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>

  <xsl:template match="node() | @*">
    <xsl:apply-templates select="testsuites"/>
  </xsl:template>

  <xsl:template match="testsuites">
   <xsl:apply-templates  select="testsuite"/>
  </xsl:template>

  <xsl:template match="testsuite">
      <xsl:apply-templates  select="testcase"/>
  </xsl:template>

  
  <xsl:template match="testcase[@name='test_edit_distance_100']">
      <xsl:value-of select="@time"/>
  </xsl:template>



</xsl:stylesheet>
