#!/bin/bash
set -ex


authentication_response="$(curl -u "$pcloudy_username:$pcloudy_access_key" https://$PCLOUDY_CLOUDURL/api/access)"
authToken=$(echo "$authentication_response" | jq -r .result.token)
upload_response="$(curl -X POST -F "file=@$upload_path" -F "source_type=raw" -F "token=$authToken" -F "filter=all" https://$PCLOUDY_CLOUDURL/api/upload_file)" 
file_name=$(echo "$upload_response" | jq -r .result.file)
$(echo $file_name | envman add --key PCLOUDY_APP_NAME)

# resigning process start from here

initiate_resigning_response="$(curl -H "Content-Tyepe:application/json" -d {"token:$authToken","filename": "$file_name"} https://$PCLOUDY_CLOUDURL/api/resign/initiate)"
resign_token_response=$(echo "$initiate_resigning_response" | jq -r .result.token)

resigning_progress="$(curl -H "Content-Tyepe:application/json" -d {"token":"$authToken","resign_token":"$resign_token_response","filename":"$file_name"} https://$PCLOUDY_CLOUDURL/api/resign/progress)"
download_resigned_respone="$(curl -H "Content-Tyepe:application/json" -d {"token":"$authToken","resign_token":"$resign_token_response","filename":"$file_name"} https://$PCLOUDY_CLOUDURL/api/resign/download)"

#Booking the device
book_pCloudy_device="$()"
