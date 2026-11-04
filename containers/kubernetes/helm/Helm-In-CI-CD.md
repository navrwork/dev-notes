# Helm in CI/CD

The chart in the app’s Git repository is the Helm chart definition. CI validates and packages that definition; CD installs the packaged chart (or the chart directly from the repository) into a Kubernetes cluster.

```mermaid
flowchart TD
    A["<b>SOURCE</b><br/>App code and Helm chart"]
    B["<b>CI - VALIDATE AND PUBLISH</b><br/>Dependencies, lint, and tests<br/>Package and publish chart"]
    C["<b>CD - DEPLOY</b><br/>Chart version and environment values<br/>Install or upgrade in Kubernetes"]
    D["<b>VERIFY AND PROMOTE</b><br/>Check rollout; promote or roll back"]

    A --> B --> C --> D
```

## Helm Chart Definition

The chart in the app’s Git repository is the Helm chart definition — its source files, such as Chart.yaml, values.yaml, and the templates/ directory.

For an application-specific chart, the chart is usually kept in the application's existing Git repository alongside its source code and CI/CD configuration. This keeps application and deployment changes versioned and reviewed together. A separate chart repository can make sense when charts are shared across multiple applications or maintained by a platform team.

If another build step generates the chart, generate it first; run the Helm validation and packaging steps afterward.

A typical repository layout might look like this:

```text
my-repo/
├── .github/
│   └── workflows/
│       └── helm-ci.yaml
└── charts/
    └── mychart/
        ├── Chart.yaml
        ├── Chart.lock             # Optional; generated for chart dependencies
        ├── values.yaml
        ├── values-dev.yaml        # Optional environment-specific overrides
        ├── values-prod.yaml       # Optional environment-specific overrides
        ├── charts/                # Optional; downloaded chart dependencies
        └── templates/
            ├── _helpers.tpl
            ├── deployment.yaml
            ├── service.yaml
            └── ingress.yaml
```

In this layout, CI commands should point to `./charts/mychart` instead of `./mychart`. `helm dependency build` downloads declared dependencies into the chart's `charts/` directory when needed.


## Prerequisites

The chart must exist before CI can validate or package it. Typically, the repository already contains `Chart.yaml`, `values.yaml`, and `templates/`, along with any dependency declarations. CI runs after a change is pushed or a pull request is opened, then checks and packages the chart.

## Helm in CI

Continuous Integration (CI) typically validates and packages a chart after a change. It does not usually need access to a Kubernetes cluster. A typical chart pipeline might run the following commands:

| Step                | Command                                                                                      | Purpose                                                                                                                        |
|---------------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Build dependencies  | `helm dependency build ./charts/mychart`                                                     | Downloads dependencies declared in `Chart.yaml`, using `Chart.lock` when present.                                              |
| Lint the chart      | `helm lint ./charts/mychart`                                                                 | Checks the chart for common structural and configuration issues.                                                               |
| Render templates    | `helm template myapp-ci ./charts/mychart -f ./charts/mychart/values-dev.yaml --namespace ci` | Renders manifests locally with development values; it does not deploy them to a cluster.                                       |
| Package the chart   | `helm package ./charts/mychart`                                                              | Creates a versioned chart archive using the chart name and version in `Chart.yaml`.                                            |
| Publish the package | `helm push ./mychart-0.1.0.tgz oci://registry.example.com/helm-charts`                       | Uploads the archive to an OCI registry. Replace the example archive name and registry with the actual package and destination. |

The chart version in the package is taken from its `version` in `Chart.yaml`.

The CI job should authenticate to the registry using credentials stored in the CI platform's secret store. It should publish a chart only after the required checks pass.

## Helm in CD

CI pushes the versioned chart archive to the OCI registry; CD then pulls the selected chart version from that registry and deploys it to the target cluster. For example, CI might publish chart version `0.1.0`, which CD deploys with production-specific values.

The CD runner needs access to both the chart registry (to pull the chart) and the target Kubernetes cluster (to install or upgrade the release). A typical deployment command is:

```bash
helm upgrade --install myapp \
  oci://registry.example.com/helm-charts/mychart \
  --version 0.1.0 \
  -f ./charts/mychart/values-prod.yaml \
  --namespace prod \
  --create-namespace \
  --wait \
  --timeout 5m
```

`upgrade --install` creates the release if it does not exist, or upgrades it if it already exists. Pinning `--version` deploys a specific chart version. CD can deploy that same immutable chart version to development, staging, and production with the appropriate values file for each environment. Use protected approvals or promotion rules before production deployment as required by your process.

After deployment, the pipeline can verify the release and workload:

```bash
helm status myapp --namespace prod
kubectl rollout status deployment/myapp --namespace prod --timeout=5m
```

If a deployment fails, the pipeline or operator can inspect release history and roll back:

```bash
helm history myapp --namespace prod
helm rollback myapp 1 --namespace prod --wait
```

The rollback revision (`1` here) is an example; choose the appropriate revision from `helm history`. CI/CD systems differ, but these Helm commands are commonly run as pipeline steps. Keep cluster credentials and sensitive configuration in the platform's secret-management facilities rather than committing them to the chart or values files.
