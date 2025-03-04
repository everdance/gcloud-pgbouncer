# gcloud-pgbouncer

pgbouncer config and deployment example with iam enabled for gcloud cloud postgresql database.

To deploy pgbouncer with google cloud sql proxy and make connection to postgresql database is not an easy set up. I initially referred the cloud sql proxy repo's [example config](https://github.com/GoogleCloudPlatform/cloud-sql-proxy/tree/main/examples/k8s-service). It does not quite provide a fully workable solution. And in my opinion, the ssl cert setup step is not quite useful in private network environment like google cloud clusters.

The most challenge issue I faced during setup process it how to make IAM authentication work in pgbouncer. After digging and playing with configuration and authentication types, I found that with hba authentication mode, we can use trust method for  IAM account in hba configuration, so authentication can be successfully established between clients and pgbouncer.

In this example repo, I've added all relevant configuration including admin account `pgbouncer` to check stats and run `admin commands`. With easy tweaks, this can be used to deploy pgbouncer with cloud sql proxy easily in google cloud environment.
