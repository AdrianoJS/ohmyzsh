amq_container="amq:5.15.10"
pg_container="embriq/pg-quant-core:12.1"

alias dockerlogin="aws ecr get-login-password|docker login -u AWS --password-stdin https://944493252375.dkr.ecr.eu-west-1.amazonaws.com"

alias startpgmem="docker stop pg-core ; docker rm -f amq pg-core-mem ; \
docker run --detach --name amq --rm -p 8161:8161 -p 61616:61616 -p 61613:61613 -p 1883:1883 -p 61614:61614 -p 1099:1099 $amq_container ; \
docker run -d --name pg-core-mem --user 999:999 -p 5434:5432 --tmpfs /var/lib/postgresql/ -e POSTGRES_PASSWORD=pgqcore $pg_container"

alias startpg="docker stop pg-core-mem ; docker rm -f amq ; \
docker run --detach --name amq --rm -p 8161:8161 -p 61616:61616 -p 61613:61613 -p 1883:1883 -p 61614:61614 -p 1099:1099 $amq_container ; \
docker start pg-core"

alias startpg_unsecure="docker stop pg-core-mem ; docker rm -f amq ; \
docker run --detach --name amq --rm -p 8161:8161 -p 61616:61616 -p 61613:61613 -p 1883:1883 -p 61614:61614 -p 1099:1099 --env UNSECURED=true $amq_container ; \
docker start pg-core"

alias startdb="docker run -d --name pg-core \
  --user 999:999 \
  -p 5434:5432 \
  -v pg-qcore-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=pgqcore \
  $pg_container"

alias stoppg="docker stop amq pg-core"
alias restartpg="stop-pg && start-pg"
