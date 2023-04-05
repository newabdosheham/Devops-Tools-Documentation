#!/bin/bash

NAMESPACE=kasten-io


#Delete helm repository
echo "--------------------Delete Helm Repo--------------------"
helm repo remove kasten

#Delete deployments
echo "--------------------Delete Deployment--------------------"
kubectl delete deploy --all -n $NAMESPACE

#Delete services
echo "--------------------Delete Services--------------------"
kubectl delete service --all -n $NAMESPACE

#Delete configmap
echo "--------------------Delete Configmap--------------------"
kubectl delete configmap --all -n $NAMESPACE

#Delete namespace
echo "--------------------Delete Namespace--------------------"
timeout 5s kubectl delete namespace $NAMESPACE

#--------------------------------------------------------------
# Enable the following 3 commands only if you cannot delete the namespace and the command
# "kubectl delete namespace kasten-io" stuck
#--------------------------------------------------------------

#Get namespace json file
echo "--------------------Get NS Json--------------------"
kubectl get namespace $NAMESPACE -o json > ns.json

#Remove kubernetes from namespace metadata to be able to delete namespace
echo "--------------------Edit NS Json--------------------"
sed -i '/"kubernetes"/d' ./ns.json

# #replace the new json with the old one
echo "--------------------Replace NS Json--------------------"
kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f ./ns.json

#--------------------------------------------------------------
#--------------------------------------------------------------
#--------------------------------------------------------------
