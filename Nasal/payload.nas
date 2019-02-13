print("----- payload.nas loaded -----");

input = {
  replay:           "sim/replay/replay-state",
  elapsed:          "sim/time/elapsed-sec",
  impact:			"/ai/models/model-impact",
};

# setup property nodes for the loop
foreach(var name; keys(input)) {
	input[name] = props.globals.getNode(input[name], 1);
}


var hit_count = 0;
var hit_callsign = "";
var hit_timer = 0;
var closest_distance = 50;

setlistener("/ai/models/model-impact", func {
	var ballistic_name = input.impact.getValue();
	var ballistic = props.globals.getNode(ballistic_name, 0);
	var closest_distance = 10000;
	var inside_callsign = "";
	if (ballistic != nil and ballistic.getNode("name") != nil and ballistic.getNode("impact/type") != nil) {
    	var typeNode = ballistic.getNode("impact/type");
		var typeOrd = ballistic.getNode("name").getValue();
		var lat = ballistic.getNode("impact/latitude-deg").getValue();
		var lon = ballistic.getNode("impact/longitude-deg").getValue();
		var elv = ballistic.getNode("impact/elevation-m").getValue();
		var impactPos = geo.Coord.new().set_latlon(lat, lon,elv);
		#print("type %s name %s ", typeNode.getValue(), " ", typeOrd);
		if ((typeOrd == "NS-23 outer round" or
			typeOrd == "NS-23 inner round")
			and typeNode.getValue() != "terrain") {
			closest_distance = 35;
			#print("we made it here");
			foreach(var mp; props.globals.getNode("/ai/models").getChildren("multiplayer")){
				#print("NS-23 impact - hit: " ~ typeNode.getValue());
				var mlat = mp.getNode("position/latitude-deg").getValue();
				var mlon = mp.getNode("position/longitude-deg").getValue();
				var malt = mp.getNode("position/altitude-ft").getValue() * FT2M;
				var selectionPos = geo.Coord.new().set_latlon(mlat, mlon, malt);
				var distance = impactPos.direct_distance_to(selectionPos);
				#print("distance = " ~ distance);
				if (distance < closest_distance) {
					closest_distance = distance;
				inside_callsign = mp.getNode("callsign").getValue();
				}
			}

			foreach(var mp; props.globals.getNode("/ai/models").getChildren("ship")){
				#print("NS-23 impact - hit: " ~ typeNode.getValue());
				var mlat = mp.getNode("position/latitude-deg").getValue();
				var mlon = mp.getNode("position/longitude-deg").getValue();
				var malt = mp.getNode("position/altitude-ft").getValue() * FT2M;
				var selectionPos = geo.Coord.new().set_latlon(mlat, mlon, malt);
				var distance = impactPos.direct_distance_to(selectionPos);
				#print("distance = " ~ distance);
				if (distance < closest_distance) {
					closest_distance = distance;
				inside_callsign = mp.getNode("name").getValue();
				}
			}
			if ( inside_callsign != "" ) {
				print("We have a hit");
				if ( inside_callsign == hit_callsign ) {
					hit_count = hit_count + 1;
					print("hit_count: " ~ hit_count);
				} else {
					hit_callsign = inside_callsign;
					hit_count = 1;
				}
				if ( hit_timer == 0 ) {
					hit_timer = 1;
					settimer(func{hitmessage("NS-23");},1);
				}
			}
		}
	}
});

var hitmessage = func(typeOrd) {
  print("inside hitmessage");
  message = typeOrd ~ " hit: " ~ hit_callsign ~ ": " ~ hit_count ~ " hits";
  defeatSpamFilter(message);
  hit_callsign = "";
  hit_timer = 0;
  hit_count = 0;
}

var spams = 0;
var spamList = [];

var defeatSpamFilter = func (str) {
  spams += 1;
  if (spams == 15) {
    spams = 1;
  }
  str = str~":";
  for (var i = 1; i <= spams; i+=1) {
    str = str~".";
  }
  var newList = [str];
  for (var i = 0; i < size(spamList); i += 1) {
    append(newList, spamList[i]);
  }
  spamList = newList;  
}

var spamLoop = func {
  var spam = pop(spamList);
  if (spam != nil) {
    setprop("/sim/multiplay/chat", spam);
  }
  settimer(spamLoop, 1.20);
}

spamLoop();

