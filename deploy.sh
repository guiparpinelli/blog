#!/usr/bin/env bash
set -euo pipefail

blog_head=$(git rev-parse HEAD)

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"
printf "\033[1;31mDeploying commit $blog_head of 'blog' \n\033[1;0m"

echo "Removing outdated public/"
rm -rf public/

git clone https://github.com/guiparpinelli/guiparpinelli.github.io.git public
rm -rf public/*

# Generate public
hugo --gc --minify --config gh-config.yml

# Add newly created/updated files
cd public

git config user.email "guilheerme.p@gmail.com"
git config user.name "Guilherme Parpinelli"

## Commit and push
if [[ $(git status --porcelain) ]]; then
	git add .

	git commit -m "Automatic site rebuild of $(date)

  This is a rebuild of commit '$blog_head'
  Respository: github.com/benmezger/blog"
else
	printf "No changes detected.\n"
fi

git push -f -q https://$GITHUB_TOKEN@github.com/guiparpinelli/guiparpinelli.github.io.git main
