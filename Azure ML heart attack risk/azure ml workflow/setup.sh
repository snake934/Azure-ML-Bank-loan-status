#!/usr/bin/env bash

suffix=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 6 )
RESOURCE_GROUP="rg-bank-loan-${suffix}"
RESOURCE_PROVIDER="Microsoft.MachineLearningServices"
REGION=("uksouth")
WORKSPACE_NAME="ws-bank-loan-${suffix}"
COMPUTE_INSTANCE="ci${suffix}"
COMPUTE_CLUSTER="aml-cluster"

# Register the Azure Machine Learning resource provider in the subscription
az provider register --namespace $RESOURCE_PROVIDER

#  Create resource group and workspace
echo "Creating a resource group and workspace"

az group create --name $RESOURCE_GROUP --location $REGION
az configure --defaults group=$RESOURCE_GROUP
az ml workspace create --name $WORKSPACE_NAME 
az configure --defaults workspace=$WORKSPACE_NAME 

echo "Sucessfully created resource group and workspace:"

echo "Create compute instance"
echo "Creating a compute instance: " $COMPUTE_INSTANCE
az ml compute create --name ${COMPUTE_INSTANCE} --size Standard_E4ds_v4 --type ComputeInstance 

echo "Create compute cluster"
echo "Creating a compute cluster: " $COMPUTE_CLUSTER
az ml compute create --name ${COMPUTE_CLUSTER} --size Standard_E4ds_v4 --max-instances 2 --type AmlCompute 
