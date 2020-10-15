#!/bin/bash

git init
find * -size +4M -type f -print >> .gitignore
git add -A
git commit -m "first commit"
git branch -M main
git remote add origin https://raychorn:d47bb48a31ed023758791c4bb57ae16fa33e3df4@github.com/raychorn/svn_myAJaxWebAppGenerator.git
git push -u origin main
