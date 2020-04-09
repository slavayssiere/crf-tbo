#!/bin/bash


if ! [ -x "$(command -v cockroach)" ]; then
  echo "Installation of cockroach"
  wget -qO- https://binaries.cockroachdb.com/cockroach-v19.2.2.linux-amd64.tgz | tar  xvz
  sudo cp -i cockroach-v19.2.2.linux-amd64/cockroach /usr/local/bin/
fi

if ! [ -x "$(command -v jq)" ]; then
  echo "Installation of jq"
  sudo apt  install -y jq
fi

DASBOARD_PATH='tmp_dashboards'
mkdir -p $DASBOARD_PATH

add_dashboard() {
  NAME=$1
  ID=$2
  REV=$3
  echo "add $NAME dashboard"
  curl -skf \
    --connect-timeout 60 \
    --max-time 60 \
    -H "Accept: application/json" \
    -H "Content-Type: application/json;charset=UTF-8" \
    https://grafana.com/api/dashboards/$ID/revisions/$REV/download | sed 's|\"datasource\":[^,]*|\"datasource\": \"Prometheus\"|g' > $DASBOARD_PATH/$NAME.json
  echo -e "\n" >> $DASBOARD_PATH/$NAME.json
}

add_dashboard "traefik" 11462 1
add_dashboard "blacbox" 11175 1
add_dashboard "cockroach-replicas" 11466 1
add_dashboard "cockroach-runtime" 11463 1
add_dashboard "cockroach-sql" 11465 1
add_dashboard "cockroach-storage" 11464 1
add_dashboard "redis" 763 3
add_dashboard "node-exporter" 9096 4

docker-compose up -d


echo "Start with:"
echo "Prometheus: http://prometheus.localhost.org"
echo "Jaeger:     http://jaeger.localhost.org"
echo "Grafana:    http://grafana.localhost.org"
echo "Swagger:    http://swagger.localhost.org"
