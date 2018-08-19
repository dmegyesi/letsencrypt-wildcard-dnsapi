#!/bin/bash

# Terminate script if any problem happens
set -e


# If staging, use another git branch
if [ "$STAGING" == "true" ]; then
  echo -e "\tWARN: using staging environment and fake certificates.\n"
  BRANCH=staging
else
  echo -e "\tWARN: using production enviroment.\n"
  BRANCH=master
fi

# Debug: force renewal
if [ "$FORCE_RENEW" == "true" ]; then
  echo -e "\tWARN: forcing renewal, no matter of expiration time.\n"
  FORCE_CMD="--force"
  COMMENT=" (force renew)"
fi


# Update git repos

# In order to make git work, we need to login to the SDK
gcloud auth activate-service-account --key-file /root/sa-dehydrated-git-key.json
gcloud config set project personal-201021


cd /etc/dehydrated
git fetch
git checkout $BRANCH
git reset --hard origin/$BRANCH
git pull


dehydrated --register --accept-terms

# Issue new certificates
dehydrated --cron --keep-going $FORCE_CMD


# Save Letsencrypt data to git
# git exit codes make the script crazy, let's disable this mode now:
set +e


cd /etc/dehydrated

git add -A . && \
git commit -m "New certificates issued at $(date +%s)$COMMENT" && \
git push

exit 0
