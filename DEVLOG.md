## Dev Notes
**3/24/2024**
Finished what feels like MVP. Below the line is adding an envelope to the engine and allowing it to be a bit more general use, but I'm not holding the project on that. It was never about making a proper synth. I think I only want it to be one so I can wedge it into other projects. All the more reason to keep doing new projects. Pretty happy with where everything has landed—not to mention delivering on schedule.

**3/23/2024**
Splash screen added. Feels a lot like a game. Depriorioritized several intended enhancements. Not going ahead with gampepad, for now. Not adding any on-norns controls. I'll add the root note selector for the drone, whatever related params make sense. From there I suspect I'll be wrapping development for a bit. I could keep tinkering with the engine and probably should. I still want to make it more of a synth engine and clean up the rough edges, but we'll see where the waning days of the month take us. Otherwise it's dev work for another day.

**3/20/2024**
Hoy! There was a bug so elusive in the generation of the maze tree that I thought I was going crazy. Turns out it was the last place I looked. Finally being able to play through a level and descend to the next with the sequence building is a real treat. Asterion comes alive in the space. The new art is grand, and I'm just generally happy. Going to do a polish run to hit MVP and decide what I want to invest in below the line. There's some pretty sloppy code that I found challenging to parse while debugging. It might be better to pay that down than to add features.

**3/18/2024**
There's a flaw in some element of the level generation (tree/lock and key) generation that allows for a few unintended consequences. It may be the tree, or perhaps some decoration logic. Anyway, it allows for the creation of unsolvable labyrinths, at least in the reality occupied by the player. This is a risk of superposition, I guess. Today's update allows for descending more deeply into the labyrinth. I flirted with the idea of ascending back to prior levels, but it introduces complexity I'm not certain I want to eat. Shipping the descent work to shift focus to identifying bugs in the level generation or rendering and ultimately make most or all puzzles solvable.

I don't know if solvable puzzles matter in a game that is an abstraction of a synth and sequencer input. But it's bothering me. I like the results musically, though.

We're getting close to done. That's good, because I'm running out of month. I'll fix the gameplay, add params for root and subdivision, add gamepad input, and then make the call on ascent and maybe even fast travel. Depends on how far I can get. Gotta wrap the must haves before worrying about the nice.

**3/16/2024**
What started as The Garden of Forking Paths and became The Circular Ruins is now Asterion. It's still a Borges, and baby they're all about destiny and mazes. This name just centers the theme and makes it more a) like a classic game name and b) makes it more digestible for the norns interface.

**3/15/2024**
Ten days of tinkering with the base synth engine for this thing, Asterion, which is likely to become the name of the script, and I can't say enough how challenging it has been to capture the sound in my head. I'm close enough now and have proven out the idea enough that I'm ready to get back to the mechanics and aesthetic. Next I'll sort out the sequence looper, Bard, and then it's all room graphics stuff and fine tuning.

**3/5/2024**
With the introduction of the rudimentary key graphic the game is now playable enough to move past the game. I'm torn between adding polish and knowing there's a bunch of work to be done on the drone and in porting back from seamstress to norns. I have a pattern for introducing a ton of variety and in the scene graphics, but doing that work at this point is fairly pointless with the API being so different. Also I haven't solved the "what it sounds like" situation, and there are more unknowns there than anywhere else so that's where the energy belongs. Then it's all programming for norns and making stuff purdy.

The downside of this approach is I did the work around the graphics in an extremely fast and dirty way. I justify this by knowing it's all going in the trash, but I could have done more interface work and eased the eventual migration. The upside is I get to tackle the biggest knot of unsolved problems first and come back for the fun stuff in tech debt cleanup.

**3/1/2024**
Figured out the basic game play mechanic at the core of programming the drone sequence in the shower. Wrote it all down and then tried to distill it into something of a file structure with AC. I've never really started a project in this way, but this one is so hard to pin down that it makes sense to tease out a bit of structure in advance. 

**2/26/2024**
Decided to build out the initial sketch in seamstress before moving to norns. The truth is it might work better as a seamstress app than a norns app at all, but I'm going to push that consideration down the line and focus on making the most of the tighter dev loop. The vision is for it to be a curious norns thing more than an app running on the computer. We'll see.

FWIW I described the concept yesterday to my friend as a "drone sequencer that you program by playing a game like Deja Vu in an incomprehensible language where each action  alters the state of the sound and the events loop in recorded time behind the most recent action, expanding with each choice."

I was originally going to call it The Garden of Forking Paths, but as I dug back into Borges the story I settled on for a namesake resonated more with the idea in the corner of my mind—straining to make something real from a dream in an incomprehensible environment. We'll see. Might change again.
