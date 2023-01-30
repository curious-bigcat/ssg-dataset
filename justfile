package := "ssg"

# List available commands 
list:
   just --list

# launch streamlit app (--server.enableCORS=false)
app:
  poetry run streamlit run app/Static_site_generators.py

# black and isort
lint:  
   black .
   isort .

# build documentation 
docs:
  poetry run sphinx-build -a docs docs/site

# show documentation in browser
show:
  python -m http.server -d docs/site  

# publish documentation to Github Pages
pages:
  poetry run ghp-import docs/site 

# create rst source for API documentation
apidoc:
  poetry run sphinx-apidoc -o docs src/{{package}}

# git pull from remote and rebase 
pull:
  git pull --rebase 

# update csv file (project-specific) 
update:
  poetry run python example/update.py
  poetry run python app/badge.py

release:
  just version | xargs -I % gh release create %   

# run pytest
test:
  poetry run pytest
  poetry run pyright src

# run precommit hook
precommit:
 pre-commit run --all-files

version:
 poetry version -s | tr -d '\r' | xargs -I % echo v%