Information Security notes (starter)

- Parachute/EMERGENCYSTOP HDL modules are safety-critical — treat as
  high-integrity components.
- Secrets (keys, certificates) must never be committed to repository.
- Use CI to scan for accidental secrets and run linting / static analysis.
- Maintain an approval workflow for changes touching `SECURITY/` or
  `mcore/` boot/FFI code.
