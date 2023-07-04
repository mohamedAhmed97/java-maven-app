#!/bin/bash
version=$1
file=$2
echo $version
echo $file
# sed -i 's/mar97\/java-web-app:v[0-9].{1,4}-[0-9]{1,}/mar97\\/java-web-app:v2.0.0-42/' ansible/deploy.yaml
# sed -i 's/mar97\/java-web-app:v[0-9].{1,4}-[0-9]{1,}/java-web-app:v1.0.9-31"/g' ansible/deploy.yaml
sed -E -i "s/(mar97\/java-web-app:v)[0-9].{1,}-[0-9]{1,}/\1$version/g" $file

if [ $? -eq 0 ]; then
    echo "The command succeeded"
else
    echo "The command failed"
fi
