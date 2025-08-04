# ImprovedSkills
**For AzerothCore using the Eluna engine**

Grants XP and bonus item procs when gathering, smelting bars, creating inks, or crafting leather. XP scales with player level; proc chances scale with profession skill. Fully configurable—adjust XP per node, or disable XP/procs as needed.

---

## Features

- 🧱 **XP System**
  - XP is granted based on the node or material used.
  - XP increases by **+1% per player level**.
    - Example: A 100 XP node gives **179 XP** at level 79.

- 🎯 **Proc System**
  - Base proc chance:
    - `gather`: 15%
    - `bar`: 15%
    - `ink`: 15%
    - `leather`: 15%
  - Bonus chance: **+1% per 100 profession skill**, up to +4%.
    - Max proc chance: **19%**

- 🎨 **Proc messages are color-coded** based on total chance:
  - Green: 15%
  - Blue: 16%
  - Purple: 17%
  - Orange: 18–19%

---

## Installation

Drop the script into your `lua_scripts` folder. No SQL or config required.

---

## Customization

Inside the script:
- Edit `gatherXP` table to change XP per node
- Change `PROC_CHANCES` to tweak base proc rates
- Toggle `ENABLE_XP` or `ENABLE_PROCS` to disable features

---

## License

Free to use and modify. **Credit required.**

**Author:** Doodihealz / Corey
