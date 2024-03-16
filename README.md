# the-circular-ruins
An inscrutable adventure game as a drone sequencer

## Dev Log
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