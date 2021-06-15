#!/bin/sh
echo "Running Confd"
echo "dashboard: \"$(bcrypt-tool hash $DASHBOARD_PASSWORD 12)\"" > /etc/confd/hashed.yaml
# Use here the backend you want or just delete the -backend parameter if you want to use just envvars
/bin/confd -onetime -backend file -file /etc/confd/hashed.yaml && echo "Running Prometheus" && /bin/prometheus --config.file=/etc/prometheus/confd-prometheus.yml --web.config.file=/etc/prometheus/confd-web-config.yml
