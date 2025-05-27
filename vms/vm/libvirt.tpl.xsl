<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="yes"/>

  <!-- copy the whole xml doc to start with -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- add <memoryBacking> element to <domain> element  -->
  <xsl:template match="/domain">
    <xsl:copy>
      <!-- apply other templates on the copy -->
      <xsl:apply-templates select="@*|*"/>
      <memoryBacking>
        <source type="memfd"/>
        <access mode="shared"/>
      </memoryBacking>
    </xsl:copy>
  </xsl:template>

  <!-- add <driver type="virtiofs".../> to <filesystem accessmode="passthrough".../>  -->
  <xsl:template match="/domain/devices/filesystem[@accessmode='passthrough']">
    <xsl:copy>
      <!-- apply other templates on the copy -->
      <xsl:apply-templates select="@*|*"/>
      <driver type="virtiofs" queue="1024"/>
    </xsl:copy>
  </xsl:template>

  %{ for hostdev in host_devices ~}
  <xsl:template match="/domain/devices">
    <xsl:copy>
      <xsl:apply-templates select="@*|*"/>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='${hostdev.source_bus}' slot='${hostdev.source_slot}' function='0x0'/>
          </source>
          <address type='pci' domain='0x0000' bus='${hostdev.address_bus}' slot='${hostdev.address_slot}' function='0x0'/>
        </hostdev>
    </xsl:copy>
  </xsl:template>
  %{ endfor ~}

</xsl:stylesheet>