<xsl:stylesheet xmlns="http://hccp.org" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml"/>

  <xsl:template match="node() | @*">
	<xsl:copy-of  select="testsuites"/>
  </xsl:template>

  <xsl:template match="testsuites">
    <foo>
    <xsl:copy-of  select="node() | @*"/>
  </foo>
</xsl:template>

</xsl:stylesheet>
