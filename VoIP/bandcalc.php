<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- http://www.voffice.com.br/bandcalc/bandcalc.php -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="description" content=”VoIP Bandwidth Calculator capable to calculate the bandwidth required for VoIP Calls using different codecs and layer 2 protocols”>
<meta name="keywords" content="VOIP, ASTERISK, TELEPHONY, PHONES, BANDWIDTH, CODECS">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>VoIP Bandwidth Calculator</title>
<script language="javascript">

var codecs;
var layer2s;

function layer2(name, payload, crtp, atm, duplex)
{
	this.name = name;
	this.payload = payload;
	this.crtp = crtp;
	this.atm = atm;
	this.duplex = duplex;
}

function codec(name, rate, defpayload, sampling, defframesperpacket, mos, mips, astsupport)
{
	this.name = name;
	this.rate = rate;
	this.defpayload = defpayload;
	this.sampling = sampling;
	this.defframesperpacket = defframesperpacket;
	this.mos = mos;
	this.mips = mips;
	this.astsupport = astsupport;
}

function inicializar() {
	codecs = new Array()
    // name, rate, defpayload, sampling, defframesperpacket, mos, mips, astsupport
	codecs[0] = new codec("g.711", 64, 20, 0.125, 160, "4.41", "~0.35", 1);
	codecs[1] = new codec("g.723-5.3", 5.3, 30, 30, 1, "3.79", "~19", 1);
	codecs[2] = new codec("g.723-6.3", 6.3, 30, 30, 1, "3.79", "~19", 1);
	codecs[3] = new codec("g.726-16", 16, 20, 0.125, 160, "2.22", "~12", 1);
	codecs[4] = new codec("g.726-24", 24, 20, 0.125, 160, "3.51", "~12", 1);
	codecs[5] = new codec("g.726-32", 32, 20, 0.125, 160, "4.24", "~12", 1);
	codecs[6] = new codec("g.726-40", 40, 20, 0.125, 160, "4.37", "~12", 1);
	codecs[7] = new codec("g.728", 16, 20, 0.625, 32, "4.24", "~36", 0);
	codecs[8] = new codec("g.729a", 8, 20, 10, 2, "4.14", "~13", 1);
	codecs[9] = new codec("g.729e",11.8, 20, 10, 2, "4.32", "~27", 0);
	codecs[10] = new codec("GSM", 13.3, 20, 20,1,"NA","~5",1);
	codecs[11] = new codec("GSM HR", 5.6, 20, 20,1,"NA","~24",0);
	codecs[12] = new codec("GSM EFR", 12.2, 20, 20,1,"NA","~18",0);
	codecs[13] = new codec("iLBC-13.3",13.3, 30, 30,1,"4.07", "~18",1);
	codecs[14] = new codec("iLBC-15.2", 15.2, 20, 20, 1, "4.14","~15",1);
	codecs[15] = new codec("Speex-5.95", 5.95, 20, 20, 1, "NA","~9 mflops",1);
	codecs[16] = new codec("Speex-8", 8, 20, 20, 1, "NA","~10 mflops",1);
	codecs[17] = new codec("Speex-11", 11, 20, 20, 1, "NA","~14 mflops",1);
	codecs[18] = new codec("Speex-15", 15, 20, 20, 1, "NA","~11 mflops",1);
	codecs[19] = new codec("Speex-18.2", 18.2, 20, 20, 1, "NA","~17.5 mflops",1);
	codecs[20] = new codec("Speex-26.4", 26.4, 20, 20, 1, "NA","~14.5 mflops",1);
	codecs[21] = new codec("Lpc10", 2.5, 22.5, 22.5, 1, "NA","NA",1);
	codecs[22] = new codec("BV-16", 16, 20, 5, 4, "4.29","~12",0);
	codecs[23] = new codec("BV-32", 32, 20, 5, 4, "NA", "~17.5",0);
	codecs[24] = new codec("g.722-48", 48, 20, 0.0625, 32 , "NA", "~10",0);
	codecs[25] = new codec("g.722-56", 56, 20, 0.0625, 32 , "NA", "~10",0);
	codecs[26] = new codec("g.722-64", 64, 20, 0.0625, 32 , "NA", "~10",0);
	codecs[27] = new codec("g.722.1-24", 24, 20, 20, 1 , "NA", "~10.3 WMOPS",0);
	codecs[28] = new codec("g.722.1-32", 32, 20, 20, 1 , "NA", "~10.3 WMOPS",0);
	codecs[29] = new codec("g.722.2-23.85", 23.85, 20, 20, 1 , "NA", "~38 WMOPS",0);

	layer2s = new Array()
	// name, payload, crtp, atm, duplex
	layer2s[0] = new layer2("IP", 0, 0, 0, 1);
	layer2s[1] = new layer2("Ethernet", 18, 0, 0, 1);
	layer2s[2] = new layer2("PPP", 6, 1, 0, 1);
	layer2s[3] = new layer2("MLPPP", 8, 1, 0, 1);
	layer2s[4] = new layer2("Frame-Relay", 7, 1, 0, 1);
	layer2s[5] = new layer2("ATM_SNAP", 16, 1, 1, 1);
	layer2s[6] = new layer2("ATM_VCMUX", 8, 1, 1, 1);
	layer2s[7] = new layer2("PPPoE", 30, 1, 1, 1);
	layer2s[8] = new layer2("PPPoA", 8, 1, 1, 1);
	layer2s[9] = new layer2("Bridge", 24, 0, 1, 1);
	layer2s[10] = new layer2("ADSL-ATM", 8, 1, 1, 1);
	layer2s[11] = new layer2("DOCSIS", 32, 0, 0, 1);
	layer2s[12] = new layer2("802.11", 108, 0, 0, 1);
}

function totalizarpayload(form)
{
	var i=0;
	var i=form.txtLayer2.selectedIndex;
	var j=0;
	var j=form.txtSession.selectedIndex;
	var onecallpayload=0;
	var iaxcells=0;
	var pps=Math.round(1000/form.duration.value,2);
	if (j=="4") {
		if (layer2s[i].atm=="1") {
			form.atmcells.value=Math.floor((((parseInt(form.voicepayload.value)+4)*(parseInt(form.txtQty.value))+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value)))/48 )+1;
			form.totalpayload.value=form.atmcells.value*53;
			onecallpayload=parseInt(form.voicepayload.value)+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value);
			form.bandwidth.value=Math.round((pps*onecallpayload*8)/1000*100)/100;
			iaxcells = Math.floor(form.totalpayload.value)/48+1;
  			form.bandwidthall.value=Math.round((pps*53*iaxcells*8)/1000*100)/100;
			form.bandwidthover.value=Math.round(form.bandwidthall.value*(1+(form.overhead.value/100))*100)/100;
		} else {
			form.totalpayload.value=Math.floor(((parseInt(form.voicepayload.value)+4)*parseInt(form.txtQty.value)+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value)));
  		    onecallpayload=parseInt(form.voicepayload.value)+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value);
			form.bandwidth.value=Math.round((pps*onecallpayload*8)/1000*100)/100;
			form.bandwidthall.value=Math.round((pps*form.totalpayload.value*8)/1000*100)/100;
    		form.bandwidthover.value=Math.round(form.bandwidthall.value*(1+(form.overhead.value/100))*100)/100;
		}
	} else {
		if (layer2s[i].atm=="1") {
			form.atmcells.value=Math.floor((parseInt(form.voicepayload.value)+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value))/48)+1;
			form.totalpayload.value=form.atmcells.value*53;
			form.bandwidth.value=Math.round(((pps*form.totalpayload.value*8)/1000)*100)/100;
			form.bandwidthall.value=Math.round((form.bandwidth.value * form.txtQty.value)*100)/100;
			form.bandwidthover.value=Math.round(form.bandwidthall.value*(1+(form.overhead.value/100))*100)/100;
		} else {
			form.totalpayload.value=parseInt(form.voicepayload.value)+parseInt(form.l2header.value)+parseInt(form.l3header.value)+parseInt(form.vpnheader.value);
    		form.bandwidth.value=Math.round(((pps*form.totalpayload.value*8)/1000)*100)/100;
			form.bandwidthall.value=Math.round((form.bandwidth.value * form.txtQty.value)*100)/100;
			form.bandwidthover.value=Math.round(form.bandwidthall.value*(1+(form.overhead.value/100))*100)/100;
		}
	}
}

function validateQty(form) {
	totalizarpayload(form);
}

function validateCodec(form){
	var i=0;
	var i = form.txtCodec.selectedIndex;
	form.frames.value = codecs[i].sampling;
    form.framesperpacket.value = codecs[i].defframesperpacket;
	form.voicepayload.value = Math.round (((codecs[i].sampling * codecs[i].defframesperpacket) * codecs[i].rate) / 8); 
	form.mos.value = codecs[i].mos;
	form.mips.value = codecs[i].mips;
	form.duration.value = codecs[i].defpayload;
	if (layer2s[i].atm=="1") {
		form.atmcells.value = Math.floor((parseInt(form.l2header.value) + parseInt(form.l3header.value) + parseInt(form.vpnheader.value) + parseInt(form.voicepayload.value))/48)+1;
	} else {
		form.atmcells.value=0;	
	}
	totalizarpayload(form);
}

function validateLayer2(form) {
	var i = 0;
	var j = 0;
	var i = form.txtLayer2.selectedIndex;
	var j = form.txtSession.selectedIndex;
	form.l2header.value=layer2s[i].payload;
    if (layer2s[i].atm=="1"){
		form.atmcells.value = Math.floor((parseInt(form.l2header.value) + parseInt(form.l3header.value) + parseInt(form.vpnheader.value) + parseInt(form.voicepayload.value))/48)+1;
	} else {
		form.atmcells.value=0;	
	}
	if (layer2s[i].crtp=="1") {
	    if (form.txtSession[j].value=="SIP" || form.txtSession[j].value=="H323" || form.txtSession[j].value=="MGCP" ) {
		    form.crtp.disabled=false;
		} else {
			form.crtp.disabled=true;
		}
	} else { 
		form.crtp.disabled=true;
	}
	totalizarpayload(form);
}

function validateSamples(form) {
	var i = 0;
	var i = form.txtCodec.selectedIndex;
	var j = 0;
	var j = form.txtLayer2.selectedIndex;
	form.duration.value=form.framesperpacket.value * form.frames.value;
	form.voicepayload.value=Math.round((codecs[i].rate*form.duration.value)/8);
	if (layer2s[j].crtp=="1") {
	    if (form.txtSession[j].value=="SIP" || form.txtSession[j].value=="H323" || form.txtSession[j].value=="MGCP" ) {
		    form.crtp.disabled=false;
		} else {
			form.crtp.disabled=true;
		}
	} else { 
		form.crtp.disabled=true;
	}
	totalizarpayload(form);
}

function validateSession(form) {
	var i = 0;
	var i = form.txtSession.selectedIndex;
	if (i<=2) {
		form.l3header.value=40;
	} else if (i==3) {
	    form.l3header.value=40;
	} else if (i==4) {
	    form.l3header.value=44;
		form.crtp.disabled=true;
	}
	totalizarpayload(form);
}

function validateVPN(form) {
	var i = 0;
	var i = form.VPN.selectedIndex;
	if (i==0) {
		form.vpnheader.value=0;
	} else if (i==1) {
		form.vpnheader.value=40;
	} else if (i==2) {
	    form.vpnheader.value=8;
	} else if (i==3) {
	    form.vpnheader.value=16;
	}
	totalizarpayload(form);
}

function validateCRTP(form) {
	if (form.crtp.checked) {
		form.l3header.value=2;
	} else {
		form.l3header.value=40;
	}	
	totalizarpayload(form);
}

</script>

<style type="text/css">
<!--
.style1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: x-large;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: small;
}
.style7 {color: #000000}
.style16 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: medium;
	color: #FFFFFF;
	font-weight: bold;
}
.style21 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: x-small; color: #000000; font-weight: bold; }
.style26 {color: #000000; font-weight: bold; font-family: Verdana, Arial, Helvetica, sans-serif; }
.style27 {color: #FFFFFF}
</style>

</head>

<div align="center">
<script type="text/javascript"><!--
google_ad_client = "ca-pub-6038160789448207";
/* Bandcalc_EN_header */
google_ad_slot = "2581269338";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
<body onLoad="inicializar()">

<table width="800" height="721" border="0" cellpadding="2" cellspacing="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" class="style26" style="border-style:solid; border-width: thin">
  <form action="handle_calc.php" method="post" name="form1" target="_self" id="form1">
    <tr bordercolor="#93B6FF" bgcolor="#93B6FF">
      <td height="33" colspan="2" bordercolor="#D9692A" bgcolor="#D9692A" style="border-style:solid; border-width: thin" >
        <div align="center" class="style7"><span class="style16"> Bandwidth Calculator for VOIP </span></div>
      </td>
    </tr>
    <tr valign="middle" class="style2">
      <td width="307" height="187" valign="top" bordercolor="#D9692A" style="border-style:solid; border-width: thin">
        <div align="left">Simultaneous calls
          <input name="txtQty" type="text" id="txtQty" value="1" size="4" maxlength="4" onChange="totalizarpayload(this.form)" />
        </div>
        <div align="left">Codec
          <select name="txtCodec" id="txtCodec" onchange="validateCodec(this.form)">
            <option value="g.711">g.711 64 Kbps (all variants)</option>
            <option value="g.723-5.3">g.723.1 5.3 Kbps</option>
            <option value="g.723-6.3">g.723.1 6.3 Kbps</option>
            <option value="g.726-16">g.726-16 Kbps</option>
            <option value="g.726-24">g.726 24 Kbps</option>
            <option value="g.726-32">g.726 32 Kbps</option>
            <option value="g.726-40">g.726 40 Kbps</option>
            <option value="g.728">g.728 16 Kbps</option>
            <option value="g.729">g.729a 8 Kbps</option>
            <option value="g.729e">g.729e 11.8 Kbps</option>
            <option value="GSM">gsm 13.3 Kbps</option>
            <option value="GSM HR">gsm-hr 5.6 Kbps</option>
            <option value="GSM EFR">gsm-efr 12.2 Kbps</option>
            <option value="iLBC-13.3">iLBC 13.3 Kbps</option>
            <option value="iLBC-15.2">iLBC 15.2 Kbps</option>
            <option value="Speex-5.95">Speex 5.5 Kbps</option>
            <option value="Speex-8">Speex 8 Kbps</option>
            <option value="Speex-11">Speex 11Kbps</option>
            <option value="Speex-15">Speex 15 Kbps</option>
            <option value="Speex-18.2">Speex 18.2 Kbps</option>
            <option value="Speex-24.6">Speex 24.6 Kbps</option>
            <option value="Lpc10">Lpc10</option>
            <option value="bv16">bv16 16 Kbps</option>
            <option value="bv32">bv32 32 Kbps</option>
            <option value="g.722-48">g.722 48 Kbps</option>
            <option value="g.722-56">g.722 56 Kbps</option>
            <option value="g.722-64">g.722 64 Kbps</option>
            <option value="g.722.1-24">g.722.1 24 Kbps</option>
            <option value="g.722.1-32">g.722.1 32 Kbps</option>
            <option value="g722.2-23.85">g.722.2 23.85 Kbps</option>
          </select>
        </div>
        Frames per packet
      <input name="framesperpacket" type="text" id="framesperpacket" value="160" size="8" maxlength="8" onChange="validateSamples(this.form)"/>
              <br />
            L2 Technology
            <select name="txtLayer2" id="txtLayer2" onchange="validateLayer2(this.form)">

              <option value="IP" selected="selected">Layer2 (IP/UDP/RTP)</option>
              <option value="Ethernet">Ethernet 802.3</option>
              <option value="PPP">PPP</option>
              <option value="MLPPP">MLPPP</option>
              <option value="Frame-Relay">Frame-Relay</option>
              <option value="ATM_SNAP">ATM_SNAP RFC1483</option>

              <option value="ATM_VCMUX">ATM_VCMUX RFC1483</option>
              <option value="PPPoE">ADSL PPPoE</option>
              <option value="PPPoA">ADSL PPPoA</option>
              <option value="Bridge">ADSL RFC1483 Bridging</option>
              <option value="ADSL-ATM">ADSL IP over ATM</option>
              <option value="DOCSIS">DOCSIS Cable Network</option>

              <option value="802.11">Wifi 802.11a/b/g</option>
            </select>
            Protocol
            <select name="txtSession" id="txtSession" onChange="validateSession(this.form)">
              <option value="SIP" selected="selected">SIP</option>
              <option value="H323">H323</option>
              <option value="MGCP">MGCP</option>

              <option value="IAX2">IAX2</option>
              <option value="IAX2_TRUNKED">IAX2 Trunked</option>
            </select>
            <br />
            VPN
            <select name="VPN" id="VPN" onChange="validateVPN(this.form)">
              <option value="none" selected="selected">NONE</option>
              <option value="ipsec">IPSEC</option>

              <option value="mpls">MPLS</option>
              <option value="mpls-vpn">MPLS with VPN</option>
        </select>
            <br />
            <label>Prot. Overhead:
            <input name="overhead" type="text" id="overhead" value="5" size="3" maxlength="3"  onChange="totalizarpayload(this.form)"/>
            </label>
            % <br />

            <input name="crtp" type="checkbox" id="crtp" value="checkbox" disabled OnClick="validateCRTP(this.form)"/>
          Compressed RTP
        <div align="center"></div></td>
      <td width="417" align="center" valign="top" bordercolor="#D9692A" bgcolor="#FFFFFF" style="border-style:solid; border-width: thin"><p align="left">
        <label></label>
      Payload:
          <input name="voicepayload" type="text" disabled id="voicepayload" value="160" size="4" maxlength="4" />
          bytes | Sampling:
          <input name="frames" type="text" id="frames" value="0.125" size="8" maxlength="8" disabled/>
          ms <br />              
          <label>MOS:
            <input name="mos" type="text" disabled="disabled" id="mos" value="4.41" size="4" maxlength="4" />

            </label>
          <label>| Mips:
            <input name="mips" type="text" disabled="disabled" id="mips" value="~0.35" size="6" maxlength="6" />
          </label>
          | Duration
          :
          <label>
          <input name="duration" type="text" disabled="disabled" id="duration" value="20" size="6" maxlength="6" />
          </label>
          ms<br />

          <label>L2 Header:
          <input name="l2header" type="text" disabled="disabled" id="l2header" value="0" size="6" maxlength="6" />
          </label>
          <label>bytes | ATM Cells:
          <input name="atmcells" type="text" disabled="disabled" id="atmcells" value="NA" size="6" maxlength="6" />
          <br />
          </label>
          <label>L3 Header:
          <input name="l3header" type="text" disabled="disabled" id="l3header" value="40" size="6" maxlength="6"/>
          </label>

          bytes
          <label></label>
          <br />
          <label>VPN Header
          <input name="vpnheader" type="text" disabled="disabled" id="vpnheader" value="0" size="6" maxlength="6" />
          </label>
          | Total payload: 
          <label>
          <input name="totalpayload" type="text" disabled="disabled" id="totalpayload" size="5" maxlength="5" />
          </label>

          bytes
          <br />
          <label>Bandwidth (one call) :
          <input name="bandwidth" type="text" disabled="disabled" id="bandwidth" size="8" maxlength="8" />
          </label>
          kbps<br />
          Bandwidth (all calls):
          <label>
          <input name="bandwidthall" type="text" id="bandwidthall" size="8" maxlength="8" disabled="disabled" />
          </label>

          kbps<br />
          Bandwidth with overhead:
          <label>
          <input name="bandwidthover" type="text" id="bandwidthover" size="8" maxlength="8" disabled="disabled" />
          </label>
      kbps</p>        </td>
    </tr>
  </form>

  <tr bordercolor="#93B6FF">
    <td height="278" colspan="2" valign="top" bordercolor="#D9692A" style="border-style:solid; border-width: thin">
      <p class="style21">1-Some codecs presented here are not supported on Asterisk&trade; PBX.<br />
      2-Payload size can be increased at the endpoint.<br />
      3-To enable iLBC 15.2 is necessary to edit the Asterisk&trade; source code.<br />
      4-Asterisk GSM&trade; is also known by GSM-FR. <br />
      5-The results obtained from the calculator should be considered only in one direction. In half-duplex networks, like 802.11b(Wifi), you should double the estimates. <br />
      6-Network design and other protocols running in the same network should be considered too. </p>

      <p class="style21">DISCLAIMER:</p>
      <p class="style21">Information obtained from using this Bandwidth Calculator is believed to be accurate. Nonetheless,   the author makes no guarantee that the results will provide any particular level   of accuracy. Results obtained from using this calculator should not be relied upon as a sole source of information. </p>
      <p align="left" class="style21">TRADEMARKS:</p>
      <p align="left" class="style21"> Asterisk&trade; is a trademark of Digium Inc, 
        Cisco is a trademark of Cisco Systems Inc. Packetcable&trade; is a trademark of Cable Television Laboratories, Inc.</p>
      <p align="center" class="style21">Copyright&copy;  2006, Flavio E. Goncalves. All rights reserved</p>
    </td>
  </tr>
</table>
</div>
</body>
</html>
