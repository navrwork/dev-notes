# What Is a Container?

A container is an isolated process that runs an application and its required files and configuration on a host. Containers use the host operating system's kernel, while container tooling provides isolation for processes, filesystems, networking, and resources. They are generally lighter than virtual machines, which typically run a separate guest operating system.

Application configuration can be packaged into an image, but environment-specific settings—such as database endpoints—are usually supplied when the container is created or started. This lets the same image run in development, staging, and production with different settings.

## What Is a Container Image?

A container image is a packaged, versioned template used to create containers. It contains the application and the filesystem content it needs, such as runtime libraries and, optionally, non-sensitive default configuration. Images are built from instructions (often a `Dockerfile`) and can be stored in a registry so they can be shared and pulled onto different hosts.

Images make it possible to distribute and deploy applications consistently: teams can build an image once, identify it by a tag or immutable digest, and use that same artifact in development, testing, and production. An image is not itself a running application; it is the input from which a container is created.

## What Belongs in an Image vs. Runtime Configuration?

| Usually belongs in the image | Usually supplied at runtime |
|---|---|
| Application binaries and source needed to run. | Environment-specific settings, such as database and service endpoints, feature flags, and log levels. |
| Runtime libraries and other required dependencies. | Credentials, API keys, certificates, and other secrets. |
| Startup scripts and non-sensitive defaults. | Persistent data and files that must change independently of the image. |

An application may include safe defaults in its image, but deployment-specific values should generally be injected when the container starts. Avoid baking passwords, tokens, or production endpoints into an image: images may be shared across environments, and values embedded in image layers can be difficult to remove securely.

Runtime configuration is provided by the system launching the container. For details on non-sensitive and sensitive settings—including Kubernetes ConfigMaps and Secrets—see [Managing Container Environment Variables](Managing-Container-Environment-Variables.md).

## Image vs. Container

| Container image | Container |
|---|---|
| A packaged, mostly immutable template. | A running (or stopped) instance created from an image. |
| Stored in a registry or on a machine. | Exists on a host and consumes host resources when running. |
| Contains the application filesystem and any packaged defaults. | Gets runtime configuration and adds runtime state, such as a writable layer, process state, networking, and allocated resources. |
| One image can be used to create many containers. | Each container has its own lifecycle; removing it does not normally remove the image. |

```text
Container image
      ├── create and start → Container 1
      ├── create and start → Container 2
      └── create and start → Container 3
```

By default, changes written inside a container's writable layer are specific to that container and are lost when it is removed. Data that must persist should be stored in a mounted volume or external storage. Rebuilding an image is the usual way to change the packaged application or its dependencies.

## Typical Lifecycle

1. Build an image from application files and a build definition.
2. Store or publish the image in a container registry.
3. Pull the image onto a host if it is not already available.
4. Create and start a container from the image, configuring its ports, environment, storage, and resource limits as needed.
5. Stop or remove the container when it is no longer needed; keep or remove the image independently.
