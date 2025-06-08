# Didactic-Database-Cluster

The following code has been written only for didactic purpose.
The code is not deplayable in a production environment!!!

This code is not structured to be run in different environments and many production features are just missing.

Also, it has not even tested, as an AWS account would be necessary to do that.

It may be useful just to suggest ideas on how a production system could be created.


# Description


A distributed PostgreSQL system can been deployed across two AWS regions (eu-west-1 as primary and eu-west-2 as disaster recovery) utilizing k3s Kubernetes clusters and the CloudNativePG operator for database management.

Region: eu-west-1 (Primary Site)

Infrastructure: 
- Four AWS VMs host a k3s cluster.
- An S3 bucket (backup-bucket-ew1) is dedicated to storing physical backups from the primary database cluster.
Database (postgres-cluster):
- A 3-node, highly available PostgreSQL cluster is deployed, managed by the CloudNativePG operator.
- This cluster runs on the data plane nodes of the k3s cluster.
- Physical Backups: Continuous Write-Ahead Log (WAL) archiving and daily full physical backups of postgres-cluster are configured, with backups stored in s3://backup-bucket-ew1/physical/.
- Logical Backups: Daily logical backups (using pg_dump) of the app_db database from postgres-cluster are scheduled (at 04:00 UTC). These dumps are stored in an S3 bucket located in the eu-west-2 region: s3://backup_bucket_ew1/dumps/.


Region: eu-west-2 (Disaster Recovery Site)

Infrastructure: 
- A single AWS VM hosts a k3s cluster. An S3 bucket in this region (backup-bucket-ew2) is used to store physical backups of the DR database instance and also receives the logical dumps from the primary cluster.
- Database (postgres-cluster-dr): A single-node PostgreSQL instance, managed by CloudNativePG, serves as the disaster recovery replica.
- Recovery Process: This instance is configured to recover from the physical backups (WALs and full backups) of the primary postgres-cluster, which are located in s3://backup_bucket_ew1/physical/.
- Physical Backups (DR Site): The postgres-cluster-dr instance also performs its own daily physical backups (at 03:00 UTC), storing them in s3://backup_bucket_ew2/physical-dr/.
- Logical Backups: Daily logical backups (using pg_dump) of the app_db database from postgres-cluster are scheduled (at 04:00 UTC). These dumps are stored in an S3 bucket located in the eu-west-2 region: s3://backup_bucket_ew2/dumps/.


Key Architectural Aspects:

- High Availability: The primary site (eu-west-1) features a 3-node PostgreSQL cluster for high availability.
- Disaster Recovery: A cross-region DR strategy is implemented with a replica cluster in eu-west-2, continuously updated via WAL streaming from the primary's backups.
- Comprehensive Backup Strategy: The system employs both physical backups (for Point-In-Time Recovery) and logical backups (for database-level granularity and migration).
- CloudNativePG Automation: Database provisioning, management, and backup processes are largely automated by the CloudNativePG operator.


![Screenshot at 2025-06-08 15-40-52](https://github.com/user-attachments/assets/399dcd4a-a78a-47cf-ac2d-8f6d57b95efc)



