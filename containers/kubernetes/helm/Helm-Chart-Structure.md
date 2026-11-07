# Helm Chart Structure

A Helm chart is a directory of metadata, default values, templates, and optional dependencies that Helm uses to render Kubernetes resources. `helm create mychart` generates a starter chart that you can customize.

## Typical Directory Layout

```text
mychart/
├── Chart.yaml           # Required chart metadata
├── values.yaml          # Default values used by templates
├── values-dev.yaml      # Optional development overrides
├── values-prod.yaml     # Optional production overrides
├── charts/              # Packaged chart dependencies
├── crds/                # Optional CustomResourceDefinitions
└── templates/           # Kubernetes resource templates
    ├── _helpers.tpl     # Reusable named template snippets
    ├── deployment.yaml
    ├── service.yaml
    └── NOTES.txt        # Optional post-install guidance
```

Environment-specific values files are a team convention, not a required Helm filename. Helm loads `values.yaml` as the chart defaults; a file supplied with `-f` overrides those defaults.

## `Chart.yaml`: Chart Metadata

`Chart.yaml` identifies the chart and describes its package metadata. A small chart might define:

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for deploying the sample application
type: application
version: 1.2.0
appVersion: "3.4.1"
kubeVersion: ">=1.27.0"
```

| Field | Purpose |
|---|---|
| `apiVersion` | Helm chart format version. Use `v2` for Helm 3 charts. |
| `name` | Chart name; must match the chart directory name when packaged or installed from a local directory. |
| `description` | Short summary of the chart. |
| `type` | `application` for deployable charts or `library` for reusable helper templates. Defaults to `application`. |
| `version` | Version of the chart package. Update it when chart content or templates change. Use a valid SemVer version, such as `1.2.0`. |
| `appVersion` | Informational version of the application packaged or deployed by the chart. It does not automatically set the image tag; templates must reference it or a value explicitly. Quote it to preserve its string form. |
| `kubeVersion` | Optional SemVer constraint describing compatible Kubernetes versions. |
| `dependencies` | Optional list of other charts required by this chart. |
| `home`, `sources`, `maintainers`, `icon`, `annotations` | Optional project links, maintainer details, chart icon, and additional metadata. |

Chart and application versions have separate meanings. For example, an application image may change from `3.4.1` to `3.4.2` while the chart version changes only if the chart package itself is updated. Many teams update both for an application release, but Helm does not require them to match.

## `values.yaml`: Default Configuration

`values.yaml` defines defaults that templates can read. For example:

```yaml
replicaCount: 1

image:
  repository: example/myapp
  tag: "3.4.1"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 8080
```

In a template, values are referenced with `.Values`, for example `{{ .Values.replicaCount }}`. A chart's values file is configuration input; it is not itself a Kubernetes resource. Avoid putting plaintext passwords, tokens, or other secrets in chart values or committed values files.

### Environment Overrides and Precedence

Keep the chart defaults in `values.yaml`; place environment-specific differences in override files such as `values-dev.yaml` or `values-prod.yaml`. Helm combines the chart defaults with supplied overrides, with the supplied values taking precedence. Command-line `--set` values override values provided through `-f` files.

```bash
helm template myapp ./mychart \
  --namespace dev \
  -f ./mychart/values-dev.yaml
```

You can provide multiple `-f` files. Later files override earlier files for duplicate keys:

```bash
helm upgrade --install myapp ./mychart \
  --namespace dev \
  --create-namespace \
  -f ./mychart/values.yaml \
  -f ./mychart/values-dev.yaml
```

## `templates/`: Kubernetes Resource Templates

Files in `templates/` are rendered by Helm, usually using Go-template expressions and values. The rendered output consists of Kubernetes resource definitions that Helm submits to the Kubernetes API when installing or upgrading a release.

For example, a Deployment template can use values for replica count and image:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      containers:
        - name: myapp
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
```

Common template contents include Deployments, Services, Ingresses, ConfigMaps, and ServiceAccounts. The chart determines which resources are rendered; not every chart creates all of these.

### Helpers and Notes

- **`templates/_helpers.tpl`** contains reusable named template snippets, commonly for labels and resource names. Files beginning with `_` are not rendered as standalone Kubernetes resources.
- **`templates/NOTES.txt`** can display helpful instructions after an install or upgrade, such as how to reach the deployed application.

## Dependencies and CRDs

- **`dependencies` in `Chart.yaml`** declares charts that this chart depends on. `helm dependency update` downloads them into `charts/`; `Chart.lock` records resolved dependency versions for repeatable builds.
- **`crds/`** can contain CustomResourceDefinitions that Helm installs before rendering the chart's templates. Helm handles CRDs differently from ordinary templates; review Helm's CRD lifecycle limitations before using this directory for resources that need upgrades or deletion.

## Render, Inspect, and Install

Render the chart locally to inspect the Kubernetes definitions without installing them:

```bash
helm lint ./mychart
helm template myapp ./mychart --namespace dev -f ./mychart/values-dev.yaml
```

Install the chart as a release:

```bash
helm install myapp ./mychart \
  --namespace dev \
  --create-namespace \
  -f ./mychart/values-dev.yaml
```

Helm renders the templates and sends the resulting resource requests to the Kubernetes API server. Kubernetes then stores and reconciles those resources; controllers create dependent resources such as Pods. See [Helm Overview](Helm-Overview.md) for the introduction and [Helm Cheat Sheet](Helm-CheatSheet.md) for common commands.
