# kubectl Command Cheat Sheet

`kubectl` is the command-line client for interacting with a Kubernetes cluster. Before running commands that change resources, verify the current context and namespace.

## Context and Cluster

| Command | Purpose |
|---|---|
| `kubectl config get-contexts` | List configured cluster contexts. |
| `kubectl config current-context` | Show the active context. |
| `kubectl config use-context CONTEXT` | Switch to a context. |
| `kubectl cluster-info` | Show cluster control-plane and service addresses. |
| `kubectl get nodes -o wide` | List cluster nodes with additional details. |
| `kubectl config set-context --current --namespace=NAMESPACE` | Set the default namespace for the current context. |

Use `-n NAMESPACE` to select a namespace for one command, or `-A` to list namespaced resources across all namespaces.

## Inspect Resources

| Command | Purpose |
|---|---|
| `kubectl get pods` | List Pods in the current namespace. |
| `kubectl get pods -A` | List Pods in all namespaces. |
| `kubectl get pods -o wide` | Include node and IP details for Pods. |
| `kubectl get deployments,services,ingress` | List common application resources. |
| `kubectl get all -n NAMESPACE` | Show common resources in a namespace. This does not include every resource type. |
| `kubectl describe pod POD` | Show detailed information and recent events for a Pod. |
| `kubectl get events --sort-by=.metadata.creationTimestamp` | Review recent cluster events in the current namespace. |
| `kubectl explain deployment.spec` | Read API documentation for a resource field. |

Add `-n NAMESPACE` to inspect resources in a particular namespace.

## Apply and Manage Resources

| Command | Purpose |
|---|---|
| `kubectl apply -f FILE.yaml` | Create or update resources declared in a manifest. |
| `kubectl apply -f DIRECTORY/` | Apply manifests from a directory. |
| `kubectl diff -f FILE.yaml` | Preview differences between a manifest and live resources. |
| `kubectl apply --dry-run=server -f FILE.yaml` | Ask the API server to validate a change without persisting it. |
| `kubectl delete -f FILE.yaml` | Delete resources declared in a manifest. |
| `kubectl scale deployment/NAME --replicas=3` | Set a Deployment's desired replica count. |
| `kubectl rollout status deployment/NAME` | Wait for a Deployment rollout and report its status. |
| `kubectl rollout history deployment/NAME` | Show rollout revisions for a Deployment. |
| `kubectl rollout undo deployment/NAME` | Roll back a Deployment to its previous revision. |
| `kubectl rollout restart deployment/NAME` | Trigger a rolling restart of a Deployment's Pods. |

Review the active context and target namespace before applying or deleting resources. Deleting a manifest can remove the resources it declares.

## Logs and Troubleshooting

| Command | Purpose |
|---|---|
| `kubectl logs POD` | Print logs from a Pod's default container. |
| `kubectl logs -f POD` | Follow a Pod's logs as they are written. |
| `kubectl logs POD -c CONTAINER` | Select a container in a multi-container Pod. |
| `kubectl logs POD --previous` | Read logs from the previous container instance, if available. |
| `kubectl exec -it POD -- sh` | Open a shell in a container, if it includes `sh`. |
| `kubectl port-forward pod/POD 8080:80` | Forward local port `8080` to port `80` on a Pod. |
| `kubectl top pods` | Show Pod CPU and memory usage, if Metrics Server is installed. |
| `kubectl top nodes` | Show node CPU and memory usage, if Metrics Server is installed. |

For multi-container Pods, add `-c CONTAINER` to `logs` or `exec`.

## Access Checks

| Command | Purpose |
|---|---|
| `kubectl auth can-i create deployments` | Check whether the current identity can perform an action. |
| `kubectl auth can-i list pods -n NAMESPACE` | Check permissions in a specific namespace. |

## Common Short Names

| Resource | Short name |
|---|---|
| Pods | `po` |
| Services | `svc` |
| Deployments | `deploy` |
| Namespaces | `ns` |
| Nodes | `no` |

For example, `kubectl get po -A` is shorthand for `kubectl get pods -A`.
