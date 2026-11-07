# Managing Container Environment Variables

Containers commonly need configuration that varies by environment, such as service hostnames, database endpoints, feature flags, or credentials. Supply these values at runtime so the same image can be used in development, staging, and production. Do not bake environment-specific values or secrets into the image.

## Non-Sensitive and Sensitive Values

| Type | Examples | Appropriate handling |
|---|---|---|
| **Non-sensitive configuration** | Service hostname or URL, database name, feature flags, log level. | Environment variables or configuration files; in Kubernetes, commonly a ConfigMap. |
| **Sensitive configuration (secrets)** | Passwords, API tokens, private keys, credentials, certificates. | A secrets mechanism with access controls; in Kubernetes, a Secret or an external secret manager integration. |

An endpoint is not automatically sensitive, but whether it should be treated as confidential depends on the system and organization. Passwords and tokens must not be stored in an image or a ConfigMap.

## How a Container Receives Configuration

The container does not usually fetch values from a ConfigMap or secret manager by itself. The runtime or platform makes values available to it, and the application reads them—commonly from environment variables or files.

- **Environment variables:** The container launcher injects key/value settings into the process environment. This is convenient and widely supported. Be aware that values can be exposed through process diagnostics or operational tooling, and environment-variable values do not change in an already-running process.
- **Mounted files:** The launcher mounts configuration or secret files into the container. This can suit applications that expect file-based configuration and can simplify some secret-handling patterns. The application must read the files and, if updates are expected, reload them appropriately.
- **Application or platform API integration:** In some systems, the application or a helper component retrieves configuration from a service at runtime. This requires suitable identity, network access, and authorization.

For local Docker usage, values can be supplied with options such as `docker run --env` or `--env-file`; files can be mounted into the container. Use an appropriate secret store rather than committing secret values to an env file or source control.

## Kubernetes ConfigMap

A **ConfigMap** is a Kubernetes resource for storing non-confidential configuration separately from an image. A Pod can expose ConfigMap values as environment variables or mount them as files. For example, this ConfigMap defines a database endpoint:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_HOST: "postgres.database.svc.cluster.local"
```

A Pod can pass that value to a container as an environment variable:

```yaml
spec:
  containers:
    - name: app
      image: example/app:1.0
      env:
        - name: DATABASE_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DATABASE_HOST
```

ConfigMaps are namespaced resources and must be available in the namespace where the consuming Pod runs. Updating a ConfigMap does not update environment variables inside already-running containers; those containers generally need to be restarted or rolled out to read the new values. Mounted ConfigMap files are updated eventually, but the application must reread them to use the changes.

## Sensitive Values in Kubernetes

A **Kubernetes Secret** is intended for sensitive values. A Pod can expose Secret keys as environment variables or mount them as files, much like ConfigMap values. However, Kubernetes Secret data is base64-encoded in its serialized representation; base64 is not encryption. Restrict access with RBAC, configure encryption at rest for the cluster, and avoid committing plaintext Secret manifests to Git.

For stronger separation of secret storage and Kubernetes manifests, use an external secret manager, such as a cloud provider's secret service or Vault. An operator can synchronize external values into Kubernetes Secrets, or a Secrets Store CSI Driver can mount them into Pods. Configure workload identity and least-privilege access, and review how the chosen integration handles rotation and persistence.

### Example: Secret as an Environment Variable

```yaml
env:
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: app-credentials
        key: database-password
```

For sensitive values, mounting a secret as a file may be preferable when the application supports it. Environment variables are available to the process at startup; changing the Secret does not change the environment of an already-running process, so a restart or rollout may be needed. Follow the secret provider's guidance for rotation and application reload behavior.
