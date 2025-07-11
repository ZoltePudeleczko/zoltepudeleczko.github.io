# Ensure the script is run from main project directory
cd "$(dirname "$0")"
cd "../homepage_portfolio"

flutter pub global run peanut
git push origin --set-upstream gh-pages --force