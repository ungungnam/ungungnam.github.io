# ungungnam.github.io

Personal homepage, served by GitHub Pages from `main`.

- `index.html` — the whole site (plain HTML, no Jekyll templating)
- `cv.pdf` — compiled CV, linked from the homepage. **Do not edit by hand**; it is
  built by CI from `cv/`
- `cv/` — the CV's LaTeX source, mirrored from Overleaf
- `.github/workflows/cv.yml` — compiles `cv/` into `cv.pdf` on every push

## Updating the CV

Overleaf is the source of truth. Edit there, then:

```sh
./scripts/sync-cv.sh
```

That pulls Overleaf into `cv/` and pushes; CI compiles the PDF and commits it
back, so run `git pull` afterwards.

### One-time setup

1. In Overleaf, open the project and go to **Menu → Sync → Git** to get the
   project's git URL. Create a token under **Account Settings → Git integration**
   (this is a paid-plan feature).
2. Add the remote:

   ```sh
   git remote add overleaf https://git.overleaf.com/<project-id>
   ```

3. Run `./scripts/sync-cv.sh`. Git will ask for credentials: use any username
   and the Overleaf token as the password. macOS keychain stores it after that.

The workflow auto-detects the `.tex` holding `\documentclass`. If the project
ever has more than one, set `ROOT_TEX` in `.github/workflows/cv.yml`.
