# RETRO SURVIVAL THING

## Brief
This is an open-world survival crafting game 
with tower defense and city sim elements.

## World & Tone
Humans have been forced into the wild by a
rogue AI hive. Even though it's thousands of
miles away, the hive city's spires can be 
seen reaching into the heavens. The hive sends
probes to eradicate remaning humans.

## Overview

### Vertical Slice 1 - /Survival/
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

### Vertical Slice 2 - /Defense & Automation/
Auto-miners and auto-crafting machines can be 
deployed in the world and connected via belts. 
They require power and regular maintenance.

Defensive structures like turrets and gates 
can be built to help the player defend their
Nexus. These structures require power and 
ammunition (if relevant). Ammunition can be
supplied via belts.

### Vertical Slice 3 - /Settlers/
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

### Vertical Slice 4 - /Drama/
Emergent relationships between settlers, and
between the player and settlers. TBD.

## Milestones

[x] Project File
[x] Character Locomotion
[x] `resource` data structure
[x] Spawn resources in world
[x] Basic UI
[ ] Character state machine
[ ] Harvest resource

## Notes

### Random thoughts
- Events with ghosts of dead NPCs
- Dialogue system like guitar tabs with words
  on one track and expressions/actions on 
  others
- Animal Crossing-esque vocaloid dialogue
  (inflection reactive to emote track?)

## Design

Godot prefers composition over inheritance,
although shallow inheritance is fine.

### Data
1. `res/ItemData.tres`

A resource that describes *what something is* 
in data - it never directly exists in the
scene tree.

Children: `ResourceData`

2. `scenes/Entity.tscn`

A scene that defines 
*how something looks and behaves* in the 
world. It requires `ItemData`.

3. `code/Interactable.gd`

A component for the `Entity` scene that 
defines *how the player interacts* with an 
`Entity`.

Children: `Gatherable`, `Pickup`, `Buildable`
