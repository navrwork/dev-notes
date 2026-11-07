# What Is Argo CD?

Argo CD is a declarative, GitOps continuous-delivery tool for Kubernetes. It watches a Git repository (or another supported source) that describes the desired state of an application, compares that state with what is running in a cluster, and synchronizes the cluster when needed.

Git is the source of truth for deployment configuration: a change is reviewed and committed there, and Argo CD reconciles the cluster to match it. Argo CD can report drift, show deployment status, and—when configured—automatically correct differences. It supports plain Kubernetes YAML, Helm charts, Kustomize, and other configuration-management plugins.

## Why Argo CD?

Kubernetes provides APIs for managing workloads, but it does not by itself provide a complete workflow for tracking deployment configuration in version control, promoting changes between environments, or seeing whether a live cluster matches the approved configuration. Argo CD adds that GitOps delivery and visibility layer.

Using Git as the deployment record makes changes reviewable and auditable, provides history for investigation and rollback, and makes it easier to reproduce a deployment. Argo CD also reduces the need for CI jobs or people to hold direct, ongoing write access to production clusters: Argo CD runs in the cluster and pulls approved configuration from its sources.

## Kubernetes Deployment Approaches

These are not simply three levels where each tool replaces the one before it. They address different parts of deploying and managing applications, and are often used together.

| Approach | What it does | Typical scope | Best suited for |
|---|---|---|---|
| **`kubectl`** | Directly sends commands or Kubernetes manifests to a cluster's API server. | Individual Kubernetes resources in the context of a selected cluster and namespace; it can also manage cluster-scoped resources when authorized. | Learning Kubernetes, inspecting resources, troubleshooting, and straightforward imperative or manifest-based changes. |
| **Helm** | Packages Kubernetes manifests into reusable charts, configures them with values, and tracks installations as releases. Helm commands use Kubernetes access to install or update those resources. | The resources included in a chart and the permissions available to Helm; often an application in a namespace. It does not automatically manage an entire cluster. | Reusing and configuring application deployments, versioning releases, and performing upgrades or rollbacks. |
| **Argo CD** | Reconciles declared application configuration from Git or another configured source with live cluster state. It can apply plain manifests, Helm charts, and other supported configuration formats. | Applications in its own cluster and any additional registered clusters, limited by its configuration and permissions. It does not automatically take over every cluster or manage every cluster service. | GitOps workflows, continuous drift detection, deployment visibility, and coordinating applications across environments or clusters. |

**A common combination:** CI builds and publishes an image; a reviewed Git change selects that image version; Argo CD deploys the configuration, which may be a Helm chart; `kubectl` remains useful for inspection and troubleshooting.

## Before and After Argo CD

| Without Argo CD | With Argo CD |
|---|---|
| A pipeline or operator runs `kubectl apply` or `helm upgrade` against a cluster. | A pipeline publishes an image and updates deployment configuration; Argo CD detects the Git change and deploys it. |
| The exact configuration applied may be difficult to trace back to a reviewed change. | Git commits and pull requests provide a history of intended deployment changes. |
| Live edits can leave the cluster different from the repository, with drift discovered later. | Argo CD continuously compares live and desired state, reports drift, and can correct it when automated sync is enabled. |
| Each pipeline may need cluster credentials and custom deployment logic. | Argo CD pulls configuration and applies it using its configured cluster access and policies. |
| Rollback often depends on pipeline-specific steps or operator knowledge. | Reverting the configuration commit gives Argo CD a prior desired state to reconcile; deployment history and health are visible in Argo CD. |

Argo CD does not build application code or container images. CI generally handles building, testing, and publishing an image; a deployment configuration change then selects the image version for Argo CD to deploy.

## Multi-Cluster and Multi-Environment Deployments

Argo CD can manage applications in its own cluster and in additional registered Kubernetes clusters. An **Application** resource describes where an application's desired configuration comes from (repository, path, and optional revision), which destination cluster and namespace it targets, and how synchronization should work.

There are several common ways to organize environments:

- Keep a shared base configuration and environment-specific overlays or values—for example, Kustomize overlays or Helm values for `dev`, `staging`, and `prod`.
- Define a separate Application for each application/environment/cluster combination. This is straightforward for a small number of deployments.
- Use an **ApplicationSet** to generate Applications from a list of clusters, directories, or other generators. This is useful when many applications or clusters follow a consistent pattern.

For example, one repository can hold an application's common configuration and separate environment overlays. Applications can then target different clusters and namespaces, using the appropriate overlay and an explicit Git revision. Teams can promote a tested version by updating the next environment's configuration rather than rebuilding the application.

Argo CD Projects can constrain which repositories, destination clusters/namespaces, and resource kinds a group of Applications may use. Access control and repository/cluster credentials should be configured with least privilege. Production can use manual sync or protected Git review and approval practices, while lower-risk environments may use automated sync. Environment separation is a configuration and access-control design choice; Argo CD does not automatically make environments isolated just because they have different names.

## Other Major Features and Uses

- **Reconciliation and drift detection:** Compare live resources with the desired state in Git, with optional automatic synchronization and self-healing.
- **Deployment visibility:** View synchronization status, health, resource relationships, and sync history in the web UI or CLI.
- **Multiple configuration sources:** Deploy manifests from Git using plain YAML, Helm, Kustomize, Jsonnet, or configured plugins.
- **Promotion and rollback workflows:** Promote by changing a version or configuration reference in Git; revert a change to restore a previous desired configuration.
- **Deployment ordering and hooks:** Use sync phases, waves, and resource hooks to coordinate dependent resources and lifecycle actions.
- **Access control and policy boundaries:** Use Projects, RBAC, and repository and destination restrictions to delegate application management.
- **Progressive delivery integration:** Argo CD can work alongside Argo Rollouts for canary and blue-green releases; Rollouts is a separate Argo project.
- **Automation interfaces:** Use the UI, CLI, API, and notifications/integrations to fit deployment status into team workflows.

Argo CD's reconciliation is not a substitute for application testing, image security checks, secret management, or a deliberate production approval policy. Avoid committing plaintext secrets to Git; integrate an appropriate secret-management solution.

## Alternatives

- **Flux CD** — another Kubernetes-native GitOps toolkit; modular and commonly operated through Kubernetes resources and CLI.
- **Rancher Fleet** — GitOps-oriented continuous delivery with a focus on managing deployments across many clusters in Rancher environments.
- **Jenkins X** — Kubernetes-focused CI/CD platform with GitOps-based environment promotion.
- **CI pipelines (for example, GitHub Actions or Jenkins)** — can deploy directly with Helm or `kubectl`; flexible, but the team must build and maintain reconciliation, drift visibility, and cluster-access workflows if needed.
