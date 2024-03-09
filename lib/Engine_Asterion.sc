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
      arg amp = 1, attack = 0.1, bandstop_hz = 50, bandstop_width = 0.5,
        breadth = 10, decay = 0.1, shimmer = 1, depth = 1, gloom = 1,
        noise_cutoff = 60, noise_amp = 0.1, osc_amp = 0.5, osc_hz = 65.41, release = 0.3;
      var sound = SinOsc.ar(osc_hz, LinRand(0.1,25.0), osc_amp * {SinOsc.kr(1).range(0.75, 1)}, {SinOsc.kr(22).range(1, 2)});
      var noise = LPF.ar({BrownNoise.ar(noise_amp)}, {SinOsc.kr(45).range(noise_cutoff - gloom, noise_cutoff)});
      var mix = Splay.ar([sound, noise]);
      var filter = BBandStop.ar(mix, bandstop_hz + {SinOsc.kr(shimmer).range(0, 10)}, bandstop_width + {SinOsc.kr(gloom).range(0, 1)});
      Out.ar(0, filter * amp);
    }).add;

    context.server.sync;

    synth = Synth(\Asterion, target:context.server);

    params = Dictionary.newFrom([
      amp: 0.75,
      attack: 0.1,
      bandstop_hz: 50,
      bandstop_width: 0.5,
      breadth: 10,
      decay: 0.1,
      shimmer: 1,
      depth: 1,
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