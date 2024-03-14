// CroneEngine_Asterion
// Borgesian WIP

// Inherit methods from CroneEngine
Engine_Asterion : CroneEngine {
  var <synth, params;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    // ADD TRIGGERS FOR THUNKS / DELAYS / SHIMMERS / AND NOTES
    SynthDef(\Asterion, {
      arg amp=0.5, attack=0.1, breadth=0.1, decay=0.1, depth=0.1, gloom=10, hz=130.813, noise_amp=0.75, release=0.3, shine=10;
      var band_hz, band_width, delay, delay_buffer, depths, filtered, high, low, mid, mix, noise, noise_cutoff, verb;
      delay_buffer = Buffer.alloc(context.server, 360);
      band_hz = hz * depth;
      band_width = 0.01 + (gloom * 0.1);
      noise_cutoff = hz - (gloom * breadth);
      low = SinOsc.ar(hz / 4 + Dust.ar(gloom * 0.01), {BrownNoise.kr(noise_amp / 4)}!5);
      mid = SinOsc.ar(hz / 2 + SinOsc.kr().range(gloom * -1, shine), {BrownNoise.kr(noise_amp / 3)}!5);
      high = SinOsc.ar(hz + SinOsc.kr().range(0, 0 + shine), {BrownNoise.kr(noise_amp)}!5);
      noise = BLowPass.ar({BrownNoise.ar({BrownNoise.kr(noise_amp)})}, noise_cutoff);
      delay = BufDelayN.ar(delay_buffer, {Mix.ar(low)} * depth, gloom);
      verb = FreeVerb.ar(high, shine * 0.1, breadth);
      mix = LeakDC.ar(Splay.ar([noise, low, mid, high, delay, verb]));
      filtered = BBandStop.ar(mix, band_hz, band_width);
      Out.ar(0, filtered * amp);
    }).add;

    context.server.sync;

    synth = Synth(\Asterion, target:context.server);

    params = Dictionary.newFrom([
      \amp: 0.5,
      \attack: 0.1, // UNUSED FOR NOW
      \breadth: 0.1, // <- NOT GOOD ENOUGH 
      \decay: 0.1, // UNUSED FOR NOW
      \depth: 0.1,
      \gloom: 10, // <- MAKE FLOAT 1
      \hz: 130.813,
      \noise_amp: 0.75,
      \release: 0.3, // UNUSED FOR NOW
      \shine: 10; // <- MAKE FLOAT 1
    ]);
    
    params.keysDo({ arg key;
      this.addCommand(key, "f", { arg msg;
        synth.set(key, msg[1])
      });
    });

    this.addCommand(\note, "i", { arg msg; synth.set(\hz, msg[1].midicps)});

    // Need to extend this to allow note_on / note_off once we get
    // things working more
  }

  free {
    synth.free;
  }
}