# gcloud-pgbouncer

pgbouncer config and deployment example with iam enabled for gcloud cloud postgresql database.

to deploy pgbouncer with google cloud sql proxy and make connection to postgresql database is not easy set up. I initially referred the cloud sql proxy repo for [example config](https://github.com/GoogleCloudPlatform/cloud-sql-proxy/tree/main/examples/k8s-service) which does not quite provide the complete solution. And in my opinion, the ssl cert setup step does not quite useful in private network environment like google cloud clusters.

The most challenge issue I faced during this discovering process it how to make authentication work for IAM with pgbouncer. Obviously, we don't want to do password based authentication with gcloud iam support for the database instances. After digging and playing with authentication types, I found that with hba authentication mode, we can set IAM account to trust method in pgbouncer configuration, so authentication is transparently passed to cloud sql proxy.

In this example repo, I've added all relevant config including admin account `pgbouncer` to check stats and run `admin commands`. With easy tweaks, this can be used to deploy pgbouncer with cloud sql proxy easily.
