 #!/bin/sh
set -e

sed -i "/appVersion/c\ \"appVersion\" : \"$CI_COMMIT_SHORT_SHA\"," $PROJECT_PATH/health.json
sed -i "/appName/c\ \"appName\" : \"$(awk -F ':[ \t]*' '/^.*"name"/ {print $2}' $PROJECT_PATH/package.json | sed 's/^"\(.*\)",$/\1/')\"," $PROJECT_PATH/health.json
sed -i "/appDescription/c\ \"appDescription\" : \"$(awk -F ':[ \t]*' '/^.*"description"/ {print $2}' $PROJECT_PATH/package.json | sed 's/^"\(.*\)",$/\1/')\"" $PROJECT_PATH/health.json