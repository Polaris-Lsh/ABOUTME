## What & why

<!-- One or two sentences: what changes, and which problem or design principle it serves. -->

## Checklist

- [ ] Respects the design principles in [CONTRIBUTING.md](../CONTRIBUTING.md): zero dependencies · one profile with no user-facing classification · on-demand (never auto-inject) · no secrets in the profile.
- [ ] `templates/en/` and `templates/zh/` kept in sync (if either changed).
- [ ] Installers tested against a throwaway home (`install.sh --home` / `install.ps1 -TargetHome`), not a real one.
- [ ] Shell scripts keep LF endings (enforced by `.gitattributes`).
- [ ] No filled-in `ABOUTME.md` / `delta.md` / `PRIVATE.md` included.
