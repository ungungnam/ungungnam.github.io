#!/usr/bin/env bash
# Pull the CV's LaTeX source from Overleaf into cv/ and push it to GitHub,
# where .github/workflows/cv.yml compiles it into cv.pdf.
#
# One-time setup (see README):
#   git remote add overleaf https://git.overleaf.com/<project-id>
#
# Credentials come from git's credential helper (macOS keychain by default),
# so the Overleaf git token is never stored in this file or the repo.
set -euo pipefail

cd "$(dirname "$0")/.."

PREFIX="cv"
REMOTE="overleaf"
BRANCH="${OVERLEAF_BRANCH:-master}"

if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
  echo "error: no '$REMOTE' remote. Run:" >&2
  echo "  git remote add $REMOTE https://git.overleaf.com/<project-id>" >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "error: working tree is dirty; commit or stash first." >&2
  git status --short >&2
  exit 1
fi

if [ -d "$PREFIX" ]; then
  echo "==> pulling $REMOTE/$BRANCH into $PREFIX/"
  git subtree pull --prefix="$PREFIX" "$REMOTE" "$BRANCH" --squash \
    -m "sync cv source from Overleaf"
else
  echo "==> first-time import of $REMOTE/$BRANCH into $PREFIX/"
  git subtree add --prefix="$PREFIX" "$REMOTE" "$BRANCH" --squash \
    -m "import cv source from Overleaf"
fi

echo "==> pushing to origin"
git push origin HEAD

cat <<'MSG'

Done. GitHub Actions is now compiling cv.pdf; watch it with:
  gh run watch
Once it commits, pull the built PDF back down with:
  git pull
MSG
