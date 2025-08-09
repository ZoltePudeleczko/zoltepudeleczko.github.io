# Ensure the script is run from main project directory
set -euo pipefail
cd "$(dirname "$0")"
cd "../homepage_portfolio"

# Remember current branch to switch back later
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# Read desired custom domain from source tree
CUSTOM_DOMAIN="$(tr -d '\r' < web/CNAME 2>/dev/null || echo "")"

# Build and commit site to local gh-pages with peanut (no push)
flutter pub global run peanut

# Create/switch to local gh-pages tracking the remote
git fetch origin gh-pages || true
if git show-ref --verify --quiet refs/heads/gh-pages; then
  git switch gh-pages
elif git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
  git switch -c gh-pages origin/gh-pages
else
  git switch --orphan gh-pages
  git reset --hard
fi

# Ensure CNAME exists at the root of gh-pages
if [ -n "$CUSTOM_DOMAIN" ]; then
  printf "%s" "$CUSTOM_DOMAIN" > CNAME
  git add CNAME
  git commit -m "Ensure CNAME present for custom domain ($CUSTOM_DOMAIN)" || true
fi

# Push
git push origin gh-pages --force

# Return to original branch
git switch "$CURRENT_BRANCH"