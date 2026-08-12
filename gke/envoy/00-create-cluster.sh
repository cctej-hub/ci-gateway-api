#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# install.sh — Install Envoy Gateway and CloudBees CI on GKE.
# -----------------------------------------------------------------------------
set -eo pipefail

set -euo pipefail

# Resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source common functions
# shellcheck source=/dev/null
source "${ROOT_DIR}/scripts/_functions.sh"

# Load environment variables
load_env "${ROOT_DIR}/.env"

REGION=us-east1 && MACHINE_TYPE=n1-standard-8
#REGION=us-east1 && MACHINE_TYPE=e2-standard-2
MIN_NODES=1 && MAX_NODES=3


gcloud services enable cloudresourcemanager.googleapis.com  --project ${PROJECT_ID}
gcloud services enable dns.googleapis.com --project ${PROJECT_ID}
gcloud services enable compute.googleapis.com --project ${PROJECT_ID}
gcloud services enable container.googleapis.com --project ${PROJECT_ID}
gcloud services enable secretmanager.googleapis.com --project ${PROJECT_ID}
sleep 10

gcloud container clusters create $CLUSTER_NAME --zone $ZONE \
    --machine-type $MACHINE_TYPE --enable-autoscaling \
    --num-nodes 1 --max-nodes $MAX_NODES \
    --min-nodes $MIN_NODES