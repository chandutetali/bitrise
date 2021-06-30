#!/bin/bash
set -ex


authentication_response="$(curl -u "$pcloudy_username:$pcloudy_access_key" https://$PCLOUDY_CLOUDURL/api/access)"
authToken=$(echo "$authentication_response" | jq -r .result.token)
upload_response="$(curl -X POST -F "file=@$upload_path" -F "source_type=raw" -F "token=$authToken" -F "filter=all" https://$PCLOUDY_CLOUDURL/api/upload_file)" 
file_name=$(echo "$upload_response" | jq -r .result.file)
$(echo $file_name | envman add --key PCLOUDY_APP_NAME)
