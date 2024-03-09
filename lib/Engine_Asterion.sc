// CroneEngine_Asterion
// Borgesian WIP

// Inherit methods from CroneEngine
Engine_Asterion : CroneEngine {
	var <synth, params;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		SynthDef(\Asterion, {
			arg amp = 1, attack = 0.1, bandstop_hz = 100, bandstop_width = 1,
				breadth = 1, decay = 0.1, shimmer = 0, depth = 1, gloom = 0,
				noise_amp = 0.1, osc_amp = 0.5, osc_hz = 65.41, release = 0.3;
			var sound = SinOsc.ar(osc_hz, rrand(0.1,25.0)!5, osc_amp * {SinOsc.kr(1)}, {SinOsc.kr(22)});
			var brown = BrownNoise.ar(noise_amp * {SinOsc.kr(45)});
			var mix = Mix.ar([sound, brown]);
			var filter = BBandStop.ar(mix, bandstop_hz, bandstop_width);
			Out.ar(0, filter * amp);
		}).add;

		context.server.sync;

		synth = Synth(\Asterion, target:context.server);

		params = Dictionary.newFrom([
			\amp, 0.75,
			\attack = 0.1,
			\bandstop_hz, 100,
			\bandstop_width, 1,
			\breadth, 1,
			\decay, 0.1,
			\shimmer, 0,
			\depth, 1,
			\gloom, 0,
			\noise_amp, 0.1,
			\osc_amp, 1,
			\osc_hz, 65.41,
			\release, 0.3;
		]);
		
		params.keysDo({ arg key;
			this.addCommand(key, "f", { arg msg;
				params[key] = msg[1]
			});
		});

		this.addCommand(\note, "i", { arg msg; synth.set(\osc_hz, msg[1].midicps)});

		// Need to extend this to allow note_on / note_off once we get
		// things working more
	}

	free {
		synth.free;
	}
}