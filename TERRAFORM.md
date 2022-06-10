# Terraform wisdom

This document contains wisdom accumulated from provisioning Terraform based infrastructure. This does not intend to be a Terraform tutorial but more best practices and some cool things we've figured out along the way.


## Storing Secrets

We're using the `kubernetes` provider to provision various pods and services. We can use the `secrets` feature to pass across keys and secrets to the pods, which in turn can use access them via environment variables.

Consider us creating a Linode Object store via Terraform.

```hcl
resource "linode_object_storage_key" "key-bucket-file-store" {
  label = "key_bucket_file_store"
  bucket_access {
    bucket_name = linode_object_storage_bucket.bucket-file-store.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
}
```

you can subsequently create a `kubernetes_secret` resource to write the keys as a secret which then get passed to the application:

```hcl
resource "kubernetes_secret" "bucket-credentials-file-store" {
  depends_on = [
    linode_lke_cluster.k8s-cluster,
    linode_object_storage_key.key-bucket-file-store
  ]

  metadata {
     name = "bucket-credentials-file-store"
  }

  data = {
    access_key = "${linode_object_storage_key.key-bucket-file-store.access_key}"
    secret_key = "${ linode_object_storage_key.key-bucket-file-store.secret_key}"
  }
}
```

If you then had the `kubeconf` exported, you could use the `kubectl` command to inspect the secret:

```sh
kubectl get secret bucket-credentials-file-store -o jsonpath='{.data}'
```


## Accessing secrets in the application

## Dependency management

Resources can depend on each other, so Terraform can ensure that a particular resource exists before another is created e.g Our K8s cluster is ready before we try and use helm to provision pods. This is done using the `depends_on` attribute inside a `resource` definition:

```
  depends_on = [
    linode_lke_cluster.k8s-cluster,
    linode_object_storage_key.key-bucket-file-store
  ]
```

## Resource naming


## Metadata


## Namespaces for resources

