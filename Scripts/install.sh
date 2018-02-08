#!/bin/bash -ex

sfctl cluster select --endpoint https://yogzvsts1.southeastasia.cloudapp.azure.com:19080 --key ./sf1.key --cert ./sf1.crt --no-verify

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
appPkgPath="$DIR/../testappApplication"

if [[ "$#" != "0" ]];then 
	version="$1"
else 
	version="1.0.0"
fi

sfctl application upload --path $appPkgPath --debug
if [ $? -ne 0 ]; then
    echo "Application copy failed."
    exit 1
fi

sfctl application provision --application-type-build-path testappApplication --debug
if [ $? -ne 0 ]; then
    echo "Application type registration failed."
    exit 1
fi

sfctl application create --app-name fabric:/testappApplication --app-type testappApplicationType  --app-version $version --debug
if [ $? -ne 0 ]; then
    echo "Application creation failed."
    exit 1
fi

echo "Install script executed successfully."
