if [ -d ".git" ]; then 
  echo "${green}.git directory exists${no_color}"; 
else 
  echo "${red}.git directory does not exist${no_color}"; 
  sleep 1
  echo "Initializing git repository"
  sleep 1
  git init 
  git add .
  git commit -m "fix: initial commit -- bootstrapped semver nodejs project"
  git tag v0.0.1
  chown -R 1000:1000 ./.git
fi