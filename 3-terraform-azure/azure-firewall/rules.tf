# Deploy rules to Azure Firewall policy.
resource "azurerm_firewall_policy_rule_collection_group" "test-one" {
  name               = "azure-firewall-test-one-policy-rcg"
  firewall_policy_id = azurerm_firewall_policy.test-one.id
  priority           = 100

  application_rule_collection {
    name     = "Office_365"
    priority = 500
    action   = "Allow"
    rule {
      name = "outbound_to_office_365_v2"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = ["10.10.20.60/32"]
      # These FQDNs are obtained from the output of the PowerShell script in the /files directory.
      destination_fqdns = ["outlook.office.com", "outlook.office365.com", "smtp.office365.com", "r1.res.office365.com", "r3.res.office365.com", "r4.res.office365.com", "*.outlook.office.com", "outlook.office365.com", "*.outlook.office.com", "outlook.office365.com", "*.outlook.com", "attachments.office.net", "*.protection.outlook.com", "*.mail.protection.outlook.com", "*.lync.com", "*.teams.microsoft.com", "teams.microsoft.com", "*.broadcast.skype.com", "broadcast.skype.com", "*.sfbassets.com", "*.keydelivery.mediaservices.windows.net", "*.streaming.mediaservices.windows.net", "mlccdn.blob.core.windows.net", "aka.ms", "*.users.storage.live.com", "*.adl.windows.com", "*.skypeforbusiness.com", "*.msedge.net", "compass-ssl.microsoft.com", "*.mstea.ms", "*.secure.skypeassets.com", "mlccdnprod.azureedge.net", "*.sharepoint.com", "ssw.live.com", "storage.live.com", "*.search.production.apac.trafficmanager.net", "*.search.production.emea.trafficmanager.net", "*.search.production.us.trafficmanager.net", "*.wns.windows.com", "admin.onedrive.com", "officeclient.microsoft.com", "g.live.com", "oneclient.sfx.ms", "*.sharepointonline.com", "spoprod-a.akamaihd.net", "*.gr.global.aa-rt.sharepoint.com", "*.svc.ms", "*-admin.sharepoint.com", "*-files.sharepoint.com", "*-myfiles.sharepoint.com", "*.microsoftstream.com", "nps.onyx.azure.net", "*.azureedge.net", "*.media.azure.net", "*.streaming.mediaservices.windows.net", "*.keydelivery.mediaservices.windows.net", "*.officeapps.live.com", "*.online.office.com", "office.live.com", "*.cdn.office.net", "contentstorage.osi.office.net", "*.onenote.com", "*.microsoft.com", "*.office.net", "*cdn.onenote.net", "ajax.aspnetcdn.com", "apis.live.net", "officeapps.live.com", "www.onedrive.com", "*.msftidentity.com", "*.msidentity.com", "account.activedirectory.windowsazure.com", "accounts.accesscontrol.windows.net", "adminwebservice.microsoftonline.com", "api.passwordreset.microsoftonline.com", "autologon.microsoftazuread-sso.com", "becws.microsoftonline.com", "clientconfig.microsoftonline-p.net", "companymanager.microsoftonline.com", "device.login.microsoftonline.com", "graph.microsoft.com", "graph.windows.net", "login.microsoft.com", "login.microsoftonline.com", "login.microsoftonline-p.com", "login.windows.net", "logincert.microsoftonline.com", "loginex.microsoftonline.com", "login-us.microsoftonline.com", "nexus.microsoftonline-p.com", "passwordreset.microsoftonline.com", "provisioningapi.microsoftonline.com", "*.hip.live.com", "*.microsoftonline.com", "*.microsoftonline-p.com", "*.msauth.net", "*.msauthimages.net", "*.msecnd.net", "*.msftauth.net", "*.msftauthimages.net", "*.phonefactor.net", "enterpriseregistration.windows.net", "management.azure.com", "policykeyservice.dc.ad.msft.net", "*.compliance.microsoft.com", "*.protection.office.com", "*.security.microsoft.com", "compliance.microsoft.com", "protection.office.com", "security.microsoft.com", "account.office.net", "*.portal.cloudappsecurity.com", "suite.office.net", "*.blob.core.windows.net", "firstpartyapps.oaspapps.com", "prod.firstpartyapps.oaspapps.com.akadns.net", "telemetryservice.firstpartyapps.oaspapps.com", "wus-firstpartyapps.oaspapps.com", "*.aria.microsoft.com", "*.events.data.microsoft.com", "*.o365weve.com", "amp.azure.net", "appsforoffice.microsoft.com", "assets.onestore.ms", "auth.gfx.ms", "c1.microsoft.com", "dgps.support.microsoft.com", "docs.microsoft.com", "msdn.microsoft.com", "platform.linkedin.com", "prod.msocdn.com", "shellprod.msocdn.com", "support.content.office.net", "support.microsoft.com", "technet.microsoft.com", "videocontent.osi.office.net", "videoplayercdn.osi.office.net", "*.office365.com", "*.cloudapp.net", "*.aadrm.com", "*.azurerms.com", "*.informationprotection.azure.com", "ecn.dev.virtualearth.net", "informationprotection.hosting.portal.azure.net", "*.sharepointonline.com", "dc.services.visualstudio.com", "mem.gfx.ms", "staffhub.ms", "*.microsoft.com", "*.msocdn.com", "*.office.net", "*.onmicrosoft.com", "o15.officeredir.microsoft.com", "officepreviewredir.microsoft.com", "officeredir.microsoft.com", "r.office.microsoft.com", "activation.sls.microsoft.com", "crl.microsoft.com", "office15client.microsoft.com", "officeclient.microsoft.com", "insertmedia.bing.office.net", "go.microsoft.com", "ajax.aspnetcdn.com", "cdn.odc.officeapps.live.com", "officecdn.microsoft.com", "officecdn.microsoft.com.edgesuite.net", "*.virtualearth.net", "c.bing.net", "excelbingmap.firstpartyapps.oaspapps.com", "ocos-office365-s2s.msedge.net", "peoplegraph.firstpartyapps.oaspapps.com", "tse1.mm.bing.net", "wikipedia.firstpartyapps.oaspapps.com", "www.bing.com", "*.acompli.net", "*.outlookmobile.com", "login.windows-ppe.net", "account.live.com", "login.live.com", "www.acompli.com", "*.appex.bing.com", "*.appex-rf.msn.com", "c.bing.com", "c.live.com", "d.docs.live.net", "directory.services.live.com", "docs.live.net", "partnerservices.getmicrosoftkey.com", "signup.live.com", "account.live.com", "auth.gfx.ms", "login.live.com", "*.yammer.com", "*.yammerusercontent.com", "*.assets-yammer.com", "www.outlook.com", "eus-www.sway-cdn.com", "eus-www.sway-extensions.com", "wus-www.sway-cdn.com", "wus-www.sway-extensions.com", "sway.com", "www.sway.com", "*.entrust.net", "*.geotrust.com", "*.omniroot.com", "*.public-trust.com", "*.symcb.com", "*.symcd.com", "*.verisign.com", "*.verisign.net", "apps.identrust.com", "cacerts.digicert.com", "cert.int-x3.letsencrypt.org", "crl.globalsign.com", "crl.globalsign.net", "crl.identrust.com", "crl3.digicert.com", "crl4.digicert.com", "isrg.trustid.ocsp.identrust.com", "mscrl.microsoft.com", "ocsp.digicert.com", "ocsp.globalsign.com", "ocsp.msocsp.com", "ocsp2.globalsign.com", "ocspx.digicert.com", "secure.globalsign.com", "www.digicert.com", "www.microsoft.com", "officespeech.platform.bing.com", "*.skype.com", "*.config.office.net", "*.manage.microsoft.com", "*.office.com", "cdnprod.myanalytics.microsoft.com", "myanalytics.microsoft.com", "myanalytics-gcc.microsoft.com", "workplaceanalytics.cdn.office.net", "*.microsoftusercontent.com", "*.azure-apim.net", "*.flow.microsoft.com", "*.powerapps.com", "autodiscover.yourtenantdirectory.onmicrosoft.com", "*.activity.windows.com", "activity.windows.com", "ocsp.int-x3.letsencrypt.org", "*.cortana.ai", "admin.microsoft.com", "cdn.odc.officeapps.live.com", "cdn.uci.officeapps.live.com"]
    }
  }

  network_rule_collection {
    name     = "network_rules_test"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "outbound_example_only"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["21", "22"]
    }
    rule {
      name                  = "outbound_to_azure"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureCloud"]
      destination_ports     = ["443"]
    }
  }
}
