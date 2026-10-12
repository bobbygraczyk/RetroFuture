# RETRO SURVIVAL THING
This is an open-world survival crafting game 
with tower defense and city sim elements.

## World
Humans have been forced into the wild by a
rogue AI hive. Even though it's thousands of
miles away, the hive city's spires can be 
seen reaching into the heavens. The hive sends
probes to eradicate remaning humans. You are 
trying to create a safe haven for drifters
and strays.

## Tone 
Survival, but hopeful. Subdued and dreamy.
The light comes out in small moments.
Humans have banned all advanced magnification
devices and long-range communication devices.
Hive bots have banned technology. It must be
destroyed immediately.

## Aesthetic
Gears, tubes, CRTs, filament. Alternative, 
punk, human.

## Overview

### Milestone 1 - *Survival*
The player spawns with a deployable Nexus and
some resource-gathering tools. The Nexus has 
extra storage, a light, and generates heat.
It also enables crafting simple tools and
weapons.

To stay alive you must stay warm, eat food,
and drink water. The player spawns with about
a day's worth of both.

Enemy robots swarm the Nexus at night. The
player must build a simple shelter around the 
Nexus, craft a weapon, and defend it until
dawn.

### Milestone 2 - *Defense & Automation*
Auto-miners and auto-crafting machines can be 
deployed in the world and connected via belts. 
They require power and regular maintenance.

Defensive structures like turrets and gates 
can be built to help the player defend their
Nexus. These structures require power and 
ammunition (if relevant). Ammunition can be
supplied via belts.

### Milestone 3 - *Settlers*
Your outpost is the only safe place for 
thousands of miles. Naturally, travellers stop
to rest. If it's safe enough and you have 
spare food and shelter, they may choose to 
stay.

Setllers can do anything you can do, but have
predefined affinities for certain skills.
There are also skills they like and dislike, 
separately from their affinities.

You can create occupation stations in 
structures, like a stove for a chef or a 
repair bench for a maintenance worker. 
Settlers will fill any open occupation.

### Milestone 4 - *Drama*
Emergent relationships between settlers, and
between the player and settlers. TBD.

## Notes

### UI Notes
- Menuing is a 'planner' or 'journal'
- You can write notes in there, see a 
  calendar, and make todos
- Inventory is in journal
- Main UI clock/date is a perpetual
  calendar watch worn by the player
  (but always displayed on UI)

### Random thoughts
- Events with ghosts of dead NPCs
- Dialogue system like guitar tabs with words
  on one track and expressions/actions on 
  others
- Animal Crossing-esque vocaloid dialogue
  (inflection reactive to emote track?)

## Code Style

### `create()` factories
Never directly create scene or class 
instances with `instantiate()` or `new()`. 

Always call the class's `create()` function, 
which should return a reference to the new 
instance.

### `instantiate()` quirk
Always call like so:
`var new_scene = scene.instantiate() as Type`
Declaring the type earlier will not be 
detected by Godot's Intellisense.
