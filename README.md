# whatnot-images

455 product photos for a Whatnot CSV bulk import, one to four per SKU.
Filenames are `SS-###_N.jpg`, matching the `SKU` column in `Whatnot_Listings.csv`.

Served by GitHub Pages so Whatnot's importer can fetch them anonymously over https.

## Publish

1. Create a **public** repo named `whatnot-images` on GitHub (no README, no .gitignore).
2. From this folder run `./push.sh YOUR_GITHUB_USERNAME`.
3. On GitHub: **Settings -> Pages -> Source: Deploy from a branch -> Branch: main / (root) -> Save.**
4. Wait ~1 minute, then open
   `https://YOUR_GITHUB_USERNAME.github.io/whatnot-images/SS-001_1.jpg`
   If the photo loads, the base URL for the CSV is
   `https://YOUR_GITHUB_USERNAME.github.io/whatnot-images/`

## Then

In `Whatnot_Listings.csv`, find-and-replace
  `https://YOURHOST.example.com/whatnot/`
with your base URL above.

Note: a GitHub Pages site is public. These are product photos, so that's fine —
just don't add anything to this repo you wouldn't want indexed.
# whatnot-images
