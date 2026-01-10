# Kubernetes Lab – Minikube

## Overview
This project simulates a production-like Kubernetes environment using Minikube.
It includes an NGINX application, ingress routing, node-level DaemonSets, and
full observability with Prometheus and Grafana.

## Architecture
- Minikube (local cluster)
- NGINX Deployment (3 replicas)
- ClusterIP Service
- NGINX Ingress Controller
- DaemonSet for node-level agents
- Prometheus & Grafana (Helm)

## How to Run
1. Start Minikube
2. Enable Ingress
3. Apply manifests
4. Access NGINX via Ingress
5. Access Grafana

## Current State (v1)
- Stateless web app
- Manual scaling
- No autoscaling
- No GitOps yet

## Next Steps
- Add ConfigMaps and Secrets
- Enable HPA
- Add GitOps with ArgoCD