web: bundle exec passenger start -p $PORT --max-pool-size 3
worker: PGBOUNCER_DEFAULT_POOL_SIZE=2 bundle exec sidekiq -c 25 -q default