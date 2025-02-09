#!/bin/bash
kubectl get pods --field-selector=status.phase=Failed | grep Evicted | awk '{print $1}' | xargs kubectl delete pod
