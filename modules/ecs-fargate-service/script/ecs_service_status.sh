#!/bin/bash -e

function log() {
    echo "$1" >&2
}

function die() {
    log "$1"
    exit 1
}

function testCommands() {
    [ ! -z "$(command -v jq)" ] || die "The 'grep' command is missing."
    [ ! -z "$(command -v aws)" ] || die "The the 'aws' command is missing."
    [ ! -z "$(command -v date)" ] || die "The the 'date' command is missing."
}

function describeService() {
    log " Checking ECS Service Status using ECS Events"
    log "aws ecs describe-services $AWS_PROFILE_ARG --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $ECS_REGION"

    ECS_CLUSTER=${ECS_CLUSTER:-cluster}
    ECS_SERVICE=${ECS_SERVICE:-service}
    ECS_REGION=${ECS_REGION:-region}

    SERVICE=$(aws ecs describe-services $AWS_PROFILE_ARG --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $ECS_REGION)
    serviceIsValid <<<$SERVICE || return 1
    cat <<<$SERVICE
}

function serviceIsValid() {
    [ "true" = "$(jq '.services | length > 0')" ]
}

function now() {
    date +%s
}

function waitForDeployment() {
    
	SLEEP_SECONDS=${SLEEP_SECONDS:-5}
	log " Waiting for $SLEEP_SECONDS seconds" 
	sleep $SLEEP_SECONDS

    START_TIME=$(now)
    while true; do
        SERVICE=$(describeService)
        (( $? == 0 )) || die "Couldn't describe the service."
      SERVICE_STEADY=$(aws ecs describe-services $AWS_PROFILE_ARG --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $ECS_REGION | jq '.services[0].events[0]' | grep "steady")
        if [ -z "$SERVICE_STEADY" ]
        then
      log " Deployment failed"
	  log " Updating the service as desired count 0 for stopping the deployment"
	  log " Running this command : aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --region $ECS_REGION --desired-count 0"
	  aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --region $ECS_REGION --desired-count 0

      return 1
      else
      log "Deployment is successful"
	  return 0
fi
    done
}


###############
# Script begins
###############


testCommands || die "Missing commands necessary to run this script."
waitForDeployment && log "Deployment finished." || die "Deployment didn't succeed."
