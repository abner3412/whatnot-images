#!/bin/bash
# Publishes these images to GitHub Pages.
# Run from this folder:   ./push.sh
set -e
REPO="whatnot-images"
cd "$(dirname "$0")"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  USER=$(gh api user --jq .login)
  echo "GitHub CLI is authenticated as $USER — doing everything in one go."
  git init -q 2>/dev/null || true
  git checkout -q -B main
  git add -A
  git -c user.email="$USER@users.noreply.github.com" -c user.name="$USER" \
      commit -q -m "Whatnot product images" || echo "(nothing new to commit)"
  gh repo create "$REPO" --public --source=. --remote=origin --push 2>/dev/null \
    || { git remote remove origin 2>/dev/null || true
         git remote add origin "https://github.com/$USER/$REPO.git"
         git push -u origin main; }
  echo "Enabling GitHub Pages..."
  gh api -X POST "repos/$USER/$REPO/pages" \
     -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
   || gh api -X PUT "repos/$USER/$REPO/pages" \
      -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
   || echo "  (couldn't set Pages via API — do it in Settings -> Pages)"
  BASE="https://$USER.github.io/$REPO/"
  echo; echo "Waiting for the first Pages build..."
  for i in $(seq 1 30); do
    code=$(curl -s -o /dev/null -w '%{http_code}' "${BASE}SS-001_1.jpg" || true)
    [ "$code" = "200" ] && break
    sleep 10
  done
  echo
  if [ "$code" = "200" ]; then echo "LIVE. Base URL for the CSV:"; else
    echo "Pushed, but Pages isn't serving yet (HTTP $code). Give it a few minutes, then use:"; fi
  echo "  $BASE"
  exit 0
fi

echo "GitHub CLI not found or not logged in."
echo "Either run:  brew install gh && gh auth login    then re-run this script,"
echo "or create a public repo named '$REPO' on github.com and run:"
echo
echo "  git init && git checkout -B main && git add -A && git commit -m 'images'"
echo "  git remote add origin https://github.com/YOURNAME/$REPO.git"
echo "  git push -u origin main"
echo
echo "then turn on Settings -> Pages -> main / (root)."
