# Monitoring

This stack includes:

- Prometheus for metrics storage
- Grafana for dashboards
- Node Exporter for host metrics
- cAdvisor for Docker metrics

Docs:

- Prometheus: https://prometheus.io/docs/introduction/overview/
- Grafana: https://grafana.com/docs/grafana/latest/
- Node Exporter: https://github.com/prometheus/node_exporter
- cAdvisor: https://github.com/google/cadvisor

## URLs

```text
Grafana:       http://localhost:3000
Prometheus:    http://localhost:9090
Node Exporter: http://localhost:9100
cAdvisor:      http://localhost:8082
```

Grafana login:

```text
username: admin
password: value of GRAFANA_ADMIN_PASSWORD in .env
```

## Prometheus Targets

Open:

```text
http://localhost:9090/targets
```

You should see:

- prometheus
- node-exporter
- cadvisor

## Grafana Dashboards

Prometheus is auto-provisioned as a Grafana datasource.

Good community dashboard IDs to import:

- Node Exporter Full: `1860`
- Docker and system monitoring examples: search https://grafana.com/grafana/dashboards/

In Grafana:

```text
Dashboards -> New -> Import -> paste dashboard ID -> select Prometheus
```
