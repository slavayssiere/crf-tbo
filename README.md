# ws_pegass

Webservice to Pegass

## Lancement en local

Pour installer, après avoir cloner le projet

```gem install bundler```

```bundle install```

Vous pouvez ajouter 'rack' et 'rerun' avec une commande 'gem install'.

```bash
export REDIS_HOST=localhost
rerun rackup
```

## Via Docker

dans env.sh à la racine :

```bash
export PEGASS_USERNAME=***
export PEGASS_PASSWORD=***
```

```bash
docker run -d --name test-pegass -p 8080:8080 test:latest
docker run -d --name some-redis -e REDIS_HOST=localhost -p 6379:6379 redis:latest

cd test
source ../env.sh
python3 test.py
```
