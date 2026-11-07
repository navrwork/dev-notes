# What Is Helm?

Helm is the package manager for Kubernetes. Like `apt`, `dnf`, or `winget`, it installs and manages packaged software; Helm's packages are called charts and define Kubernetes resources for applications in a cluster. Helm also helps configure, upgrade, and roll back those installations. Unlike OS package managers, it manages Kubernetes resources through the cluster's API rather than installing software directly onto a machine.

## Why Helm

Even a basic Kubernetes application can involve several YAML manifest files:

- **Deployment** — describes the application’s containers and how they should run.
- **Service** — provides stable networking to reach the application inside the cluster.
- **Ingress** — optionally manages HTTP or HTTPS access from outside the cluster.
- **ConfigMap** — stores non-sensitive configuration such as application properties.

Maintaining separate, mostly duplicated manifests for each environment—such as development, staging, and production—can become difficult to manage. Changes need to be kept consistent across files and environments, and applying resources individually can make deployments harder to repeat and track.

## What Helm Does

Helm packages Kubernetes manifests into reusable **charts** and makes their configuration easier to manage with **values**.

### Charts: The Application Package and Templates

A chart is a versioned, reusable package containing templates for Kubernetes resources, such as Deployments, Services, Ingresses, and ConfigMaps, along with chart metadata and default configuration. You can create your own chart or install a chart published by others for software such as WordPress, Prometheus, or a database.

The chart's templates use Helm's Go-template syntax to refer to configurable values. For example, a Deployment template can use values for replica count and container image:

```yaml
spec:
  replicas: {{ .Values.replicaCount }}
  template:
    spec:
      containers:
        - name: myapp
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

### Values: Default and Environment Configuration

The chart's `values.yaml` provides defaults for settings such as replica counts, image tags, and CPU or memory requests and limits. Separate values files can override those defaults for each environment without changing the templates.

For example, `dev-values.yaml` might set `replicaCount: 1` and the image tag to `dev`, while `prod-values.yaml` sets `replicaCount: 5` and the tag to `v1.2.0`. Both environments use the same chart but render different Kubernetes manifests:

```bash
helm install myapp-dev ./mychart -f dev-values.yaml
helm install myapp-prod ./mychart -f prod-values.yaml
```

Avoid storing plaintext passwords or other sensitive credentials in values files. Use Kubernetes Secrets or an external secret-management solution instead.

Each installation is a **release**: a named instance of a chart that Helm tracks. Release history makes it possible to inspect prior revisions and roll back an upgrade.

## Core Chart Files and Directory Structure

A Helm chart includes more than templates. Its core files and directories commonly look like this:

```text
my-app-chart/
├── Chart.yaml
├── values.yaml
├── charts/                   # Optional chart dependencies
└── templates/
    ├── _helpers.tpl
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

- **`Chart.yaml`** — chart metadata, including its name, description, maintainers, and versions. `version` is the chart package version and should change when the chart changes. `appVersion` indicates the application version; it is informational and does not automatically determine the container image tag.
- **`values.yaml`** — the default configuration used by templates. Environment-specific values files can override these defaults.
- **`templates/`** — Kubernetes resource templates that Helm renders using the selected values.
- **`charts/`** — optional dependencies on other charts.
- **`templates/_helpers.tpl`** — commonly used for reusable named template snippets; it does not render as a Kubernetes resource on its own.

For details on `Chart.yaml` fields, values precedence, templates, and dependencies, see [Helm Chart Structure](Helm-Chart-Structure.md).

## A Single-Command Example

Without Helm, installing an application may mean applying several Kubernetes manifest files individually. With a chart available in an OCI registry, you can install it as a release with one command:

```bash
helm install my-database oci://registry.support.pack/postgres
```

The chart reference above is an example; use the OCI registry and chart path provided by your chart publisher. If an upgrade causes problems, roll back the release to a previous revision:

```bash
helm rollback my-database
```

Helm uses the latest prior revision by default. You can specify a revision number when you need to roll back to a particular point in the release history.