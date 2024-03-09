// CroneEngine_Asterion
// Borgesian WIP

// Inherit methods from CroneEngine
Engine_Asterion : CroneEngine {
	var <synth;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		SynthDef(\Asterion, {
			arg amp = 1, oscfreq = 140.0, n = 3, ffreq = 100.0, fwidth = 5.0;
			var sound = SinOsc.ar(oscfreq* (0.1 * {SinOsc.kr(10)}), rrand(0.1,1.0), {SinOsc.kr(22)});
			var brown = BrownNoise.ar(0.1 * {SinOsc.kr(45)});
			var mix = Mix.ar([sound, brown]);
			var filter = BBandStop.ar(mix, ffreq, fwidth);
			Out.ar(0, filter * amp);
		}).add;

		context.server.sync;

		synth = Synth(\Asterion, target:context.server);
		
		this.addCommand("amp", "f", { arg msg; synth.set(\amp, msg[1])});
		this.addCommand("filter_freq", "f", { arg msg; synth.set(\ffreq, msg[1])});
		this.addCommand("filter_width", "f", { arg msg; synth.set(\fwidth, msg[1])});
		this.addCommand("note", "i", { arg msg; synth.set(\oscfreq, msg[1].midicps)});
	}

	free {
		synth.free;
	}
}