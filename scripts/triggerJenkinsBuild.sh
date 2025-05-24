#!/bin/bash
echo "Sending Webhook"
RESPONSE=$(curl \
	--fail-with-body \
	--silent \
	--form-string "job=$1" \
	--form-string "token=$2" \
	--write-out "%{response_code}" \
	"$3")
if [[ $RESPONSE == 201 ]]; then
	echo 'Queued Successfully'
	exit 0
elif [[ $RESPONSE == 303 ]]; then
	echo 'Build Already Scheduled'
	exit 1
else
	echo 'Unknown Error'
	exit 255
fi

;agjihbnkaew;ivbjszogirqp'3w4g28a95 uja2wqp3['i5mfunqa2vmUW3[PTR9JA3W4TIBGVH3JN4P[5TB9]GMAW0I234,TV\Q3W4[T]]]