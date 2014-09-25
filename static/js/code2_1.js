var map;

function initialize() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.addControl(new GMapTypeControl());
    map.addControl(new GLargeMapControl());
    map.setCenter(new GLatLng(35.694354,139.756973), 12);

    var selectHtml ="";
    selectHtml += "<form>";
    selectHtml += "<select id='rosenname' onChange='dispRosen()'>";
    selectHtml += "<option value='0'>選択してください</option>";
    selectHtml += "<option value='./data/metro-yurakucho.json'>有楽町線</option>";
    selectHtml += "<option value='./data/metro-ginza.json'>銀座線</option>";
    selectHtml += "<option value='./data/metro-hibiya.json'>日比谷線</option>";
    selectHtml += "<option value='./data/metro-touzai.json'>東西線</option>";
    selectHtml += "<option value='./data/metro-marunouchi.json'>丸ノ内線</option>";
    selectHtml += "<option value='./data/metro-chiyoda.json'>千代田線</option>";
    selectHtml += "<option value='./data/metro-hanzomon.json'>半蔵門線</option>";
    selectHtml += "<option value='./data/metro-nanboku.json'>南北線</option>";
    selectHtml += "</select>";
    selectHtml += "</form>";
    document.getElementById("rosen").innerHTML = selectHtml;
  }
}

function dispRosen(){
  var val = document.getElementById("rosenname").value;

  if (val != "0"){
    map.clearOverlays();
    map.setCenter(new GLatLng(35.694354,139.756973), 12);

    GDownloadUrl(val, createMap);
  }
}

function createMap(jsondata, statusCode){
  var json = eval("(" + jsondata + ")");

  var polyline = [];

  var selectHtml = "";
  selectHtml += "<form>";
  selectHtml += "<select id='ekiname' onChange='selectStation()'>";
  selectHtml += "<option value='0'>選択してください</option>";

  for (var i = 0; i < json.marker.length; i++) {
    var id = json.marker[i].id;
    var sta = json.marker[i].sta;
    var url = json.marker[i].url;
    var addr = json.marker[i].addr;
    var lat = json.marker[i].lat;
    var lng = json.marker[i].lng;

    var marker = createMarker(id, sta, url, addr, lat, lng)
    map.addOverlay(marker);

    selectHtml += "<option value='" + lat + "," + lng + "'>"
    selectHtml += sta;
    selectHtml += "</option>";

    polyline.push(new GLatLng(lat, lng));
  }

  selectHtml += "</select>";
  selectHtml += "</form>";
  document.getElementById("eki").innerHTML = selectHtml;

  map.addOverlay(new GPolyline(polyline, "#FF0000", 5));
}

function createMarker(id, sta, url, addr, lat, lng){
  var marker = new GMarker(new GLatLng(lat, lng));

  var html = "";
  html += "<p><a href='" + url + "'>" + "[" + id + "]" + sta + "</a></p>";
  html += "<p>" + addr + "</p>";

  GEvent.addListener(marker, "click", function(){
    marker.openInfoWindowHtml(html);
  });

  return marker;
}

function selectStation(obj){
  var val = document.getElementById("ekiname").value;

  if (val != "0"){
    var latlng = val.split(",");
    var lat = latlng[0];
    var lng = latlng[1];

    map.setCenter(new GLatLng(lat, lng), 14);
  }
}
