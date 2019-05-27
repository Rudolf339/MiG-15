var reticle = canvas.new({
	"name": "Gunsight",
	"size": [1024, 1024],
	"view": [1024, 1024],
	"mipmapping": 1});

reticle.setColorBackground(0, 0, 0, 0.1);
reticle.addPlacement({"node": "reticle"});

var pipper = reticle.createGroup();

var test = pipper.createChild("text", "testing")
	.setTranslation(500, 500)
	.setAlignment("center-center")
	.setFont("LiberationFonts/LiberationSans-Regular.ttf")
	.setFontSize(64, 1.2)
	.setColor(1, 0, 0)
	.setText("Text comes here");

test.hide();
test.setText("Hello World").show();

