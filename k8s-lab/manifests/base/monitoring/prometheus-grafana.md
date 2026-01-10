# Monitoring – Prometheus & Grafana

## Overview
This project uses the kube-prometheus-stack Helm chart to provide
cluster-level monitoring and observability.

The stack includes:
- Prometheus (metrics collection)
- Grafana (visualization)
- Alertmanager
- node-exporter (DaemonSet)
- kube-state-metrics

## Why Helm
Managing Prometheus and Grafana via raw manifests is complex and error-prone.
Helm allows versioned, reproducible installs and easy upgrades.

## Installation
Monitoring is installed using Helm:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack