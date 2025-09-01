# Helm chart

This folder contains the helm chart with all the kubernetes resources for the application. The chart may or may not be packaged. 

## How to run
```bash
  helm upgrade --install --atomic -n <namespace> <release-name> .
```
