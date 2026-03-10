FPGA safety modules (placeholders)

Files:
- parachute.v         — parachute release controller (simple stub)
- emergency_stop.v    — latched emergency-stop input (simple stub)

Notes:
- These are *safety-critical* placeholders for development only. Do NOT use
  in production without hardware design review, watchdogs, redundancy,
  formal verification, and hardware interlocks.
- Add unit testbenches (Sim), timing constraints, and a hardware safety
  review checklist before synthesis.
