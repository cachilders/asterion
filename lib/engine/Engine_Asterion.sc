// CroneEngine_Asterion
// Borgesian Drone

// Inherit methods from CroneEngine
Engine_Asterion : CroneEngine {
  var <synth, params;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    // TODO Expand with trigger and env
    SynthDef(\Asterion, {
      arg amp=0.0, attack=0.1, breadth=0.1, decay=0.1, depth=0.1, gloom=0.01, hz=130.813, noise_amp=0.5, release=0.3, shine=0.1, t_gate;
      var band_hz, band_width, delay, delay_buffer, filtered, high, low, mid, mix, noise, noise_cutoff, verb;
      delay_buffer = Buffer.alloc(context.server, 360);
      band_hz = hz - ((hz / 2) * depth);
      band_width = 3 * breadth;
      noise_cutoff = hz * breadth;
      low = SinOsc.ar(hz / 4 + Dust.ar(gloom), {BrownNoise.kr(noise_amp / 4)}!5, gloom);
      mid = SinOsc.ar(hz / 2 + SinOsc.kr().range(0 - gloom, shine), {BrownNoise.kr(noise_amp / 3)}!5, breadth * depth);
      high = SinOsc.ar(hz + SinOsc.kr().range(0, shine), {BrownNoise.kr(noise_amp)}!5, shine);
      noise = BLowPass.ar({BrownNoise.ar({BrownNoise.kr(noise_amp)})}, noise_cutoff);
      delay = BufDelayN.ar(delay_buffer, {Mix.ar(low)} * depth, gloom * 5);
      verb = FreeVerb.ar({Mix.ar(high)}, shine, breadth, depth);
      mix = LeakDC.ar(Splay.ar([low, mid, high, noise, delay, verb]));
      filtered = BBandStop.ar(mix, band_hz, band_width);
      Out.ar(0, Limiter.ar(filtered * amp));
    }).add;

    context.server.sync;

    synth = Synth(\Asterion, target:context.server);

    params = Dictionary.newFrom([
      \amp: 0.5,
      // \attack: 0.1, // UNUSED FOR NOW
      \breadth: 0.1,
      // \decay: 0.1, // UNUSED FOR NOW
      \depth: 0.1,
      \gloom: 0.1,
      \hz: 130.813,
      \noise_amp: 0.5,
      // \release: 0.3, // UNUSED FOR NOW
      \shine: 0.5;
    ]);
    
    params.keysDo({ arg key;
      this.addCommand(key, "f", { arg msg;
        synth.set(key, msg[1])
      });
    });

    this.addCommand(\note, "i", { arg msg; synth.set(\hz, msg[1].midicps)});
  }

  free {
    synth.free;
  }
}