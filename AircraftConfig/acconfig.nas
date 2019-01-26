# Aircraft Config Center
# Joshua Davidson (it0uchpods)

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

setprop("/systems/acconfig/options/no-rendering-warn", 0);
var rendering_dlg = gui.Dialog.new("sim/gui/dialogs/rendering/dialog", "Aircraft/MiG-15/AircraftConfig/rendering.xml");

setlistener("/sim/signals/fdm-initialized", func {
	readSettings();
	if (getprop("/systems/acconfig/options/no-rendering-warn") != 1) {
		renderingSettings.check();
	}
	writeSettings();
});

var renderingSettings = {
	check: func() {
		var rembrandt = getprop("/sim/rendering/rembrandt/enabled");
		var ALS = getprop("/sim/rendering/shaders/skydome");
		var customSettings = getprop("/sim/rendering/shaders/custom-settings") == 1;
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!rembrandt and (!ALS or !customSettings or !landmass or !model)) {
			rendering_dlg.open();
		}
	},
	fixAll: func() {
		me.fixCore();
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!landmass) {
			setprop("/sim/rendering/shaders/landmass", 4);
		}
		if (!model) {
			setprop("/sim/rendering/shaders/model", 2);
		}
	},
	fixCore: func() {
		setprop("/sim/rendering/shaders/skydome", 1); # ALS on
		setprop("/sim/rendering/shaders/custom-settings", 1);
		gui.popupTip("Rendering Settings updated!");
	},
};

var readSettings = func {
	io.read_properties(getprop("/sim/fg-home") ~ "/Export/MiG-15-config.xml", "/systems/acconfig/options");
}

var writeSettings = func {
	io.write_properties(getprop("/sim/fg-home") ~ "/Export/MiG-15-config.xml", "/systems/acconfig/options");
}
