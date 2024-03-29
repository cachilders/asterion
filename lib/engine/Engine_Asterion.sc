// CroneEngine_Asterion
// Borgesian Drone

// Inherit methods from CroneEngine
Engine_Asterion : CroneEngine {
  var <drone, params, voice, voice_next, voice_on, voice_off, <voices;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    SynthDef(\Asterion, {
      arg amp=0.0, attack=0.1, breadth=0.1, decay=0.1, depth=0.1, gate=1, gloom=0.01, hz=65.41, noise_amp=0.5, release=0.3, shine=0.1, sustain=1;
      var band_hz, band_width, delay, delay_buffer, env, filtered, high, low, mid, mix, noise, noise_cutoff, verb;
      env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate);
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
      Out.ar(0, Limiter.ar(filtered * amp * env));
    }).add;

    context.server.sync;

    drone = Synth(\Asterion, target:context.server);

    params = Dictionary.newFrom([
      \amp: 0.5,
      \attack: 0.1,
      \breadth: 0.1,
      \decay: 0.1,
      \depth: 0.1,
      \gate: 1,
      \gloom: 0.1,
      \hz: 130.813,
      \noise_amp: 0.5,
      \release: 0.3,
      \shine: 0.5,
      \sustain: 1;
    ]);
    
    params.keysDo({ arg key;
      this.addCommand(key, "f", { arg msg;
        drone.set(key, msg[1])
      });
    });

    // note commands select or cycle through five voices in addition to the drone,
    // which are controlled with command arguments.
    voices = Array.fill(5, Synth(\Asterion, [\gate, 0], target:context.server));

    voice_next = {voice = (voice+1).wrap(0, 4)}

    voice_on = ({
      arg id, note_num, velocity, attack, decay, sustain, release;
      var hz=if(note_num.notNil, {note_num.midicps}, {params[\hz]});
      var amp=if(velocity.notNil, {1/127 * velocity}, {params[\amp]});

      id=if(id.notNil, {id}, {var v = voice; voice_next.(); v});
      attack=if(attack.notNil, {attack}, {params[\attack]});
      decay=if(decay.notNil, {decay}, {params[\decay]});
      sustain=if(sustain.notNil, {sustain}, {params[\sustain]});
      release=if(release.notNil, {release}, {params[\release]});

      voice_off.(id);
      voices[id].set(\amp, amp, \hz, hz, \attack, attack, \decay, decay, \sustain, sustain. \release, release, \gate, 1)
    })

    voice_off = ({|i|; voices[i].set(\gate, 0);})

    this.addCommand(\note, "i", { arg msg; drone.set(\hz, msg[1].midicps)});

    this.addCommand(\note_on, "iiiffff", {
      // id, note_num, velocity, attack, decay, sustain, release
      arg msg;
      voice_on.(msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7]);
    });

    this.addCommand(\note_off, "i", {arg msg;
      voice_off.(msg[1])
    });

    // One-shot with duration argument
    this.addCommand(\play_note, "iifffff", {
      // note_num, velocity, duration, attack, decay, sustain, release
      arg msg;
      var v = voice
      voice_next.()
      voice_on.(v, msg[1], msg[2], msg[4], msg[5], msg[6], msg[7]);
      SystemClock.sched(msg[3], {voice_off.(v)})
    });
  }

  free {
    voices.do({arg synth; synth.free});
    drone.free;
  }
}