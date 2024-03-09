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
      arg amp = 1, attack = 0.1, bandstop_hz = 65, bandstop_width = 1,
        decay = 0.1, shimmer = 1, gloom = 1, noise_cutoff = 100,
        noise_amp = 0.5, osc_amp = 0.4, osc_hz = 130.813, release = 0.3;
      var low = SinOsc.ar(osc_hz / 2, LinRand(0.1,5.0), osc_amp * {SinOsc.kr(1).range(0.75, 1)}, {SinOsc.kr(22).range(1, gloom * 0.1)});
	    var mid = SinOsc.ar(osc_hz, LinRand(5,15.0), osc_amp * {SinOsc.kr(1).range(0.25, 0.75)}, {SinOsc.kr(22).range(1, 2)});
	    var high = SinOsc.ar(osc_hz * 2, LinRand(15,25.0), osc_amp * {SinOsc.kr(1).range(0.01, 0.25)}, {SinOsc.kr(22).range(1, shimmer * 0.1)});
      var noise = LPF.ar({BrownNoise.ar(noise_amp)}, {SinOsc.kr(45).range(noise_cutoff - gloom, noise_cutoff)});
	    var mix = SplayAz.ar(2, [low, noise, mid, high], {SinOsc.kr(1).range(0.75, 1.25)}, 1, 1.5, 0.75, 0.5, true);
      var filter = BBandStop.ar(mix, bandstop_hz + {SinOsc.kr(shimmer).range(0, 10)}, bandstop_width + {SinOsc.kr(gloom).range(0.5, 1)});
	    Out.ar(0, filter * (amp - osc_amp));
    }).add;

    context.server.sync;

    synth = Synth(\Asterion, target:context.server);

    params = Dictionary.newFrom([
      amp: 0.75,
      attack: 0.1,
      bandstop_hz: 50,
      bandstop_width: 0.5,
      decay: 0.1,
      shimmer: 1,
      gloom: 0.1,
      noise_amp: 0.1,
			noise_cutoff: 60,
      osc_amp: 0.5,
      osc_hz: 65.41,
      release: 0.3;
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