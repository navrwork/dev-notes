# Docker Notes

## Docker Setup for Windows
* [Download Docker for Windows | docker.com](https://www.docker.com/products/docker-desktop/)
* [Docker Hub](https://hub.docker.com/)
* [Docker CheatSheet | docker.com](https://docs.docker.com/get-started/docker_cheatsheet.pdf)
* [Docker CLI | docker.com](https://docs.docker.com/engine/reference/commandline/cli/)
* [Docker CLI Reference | docker.com](https://docs.docker.com/reference/cli/docker/)

## Run Container Via Docker Desktop
* Launch Docker Desktop
* Search for any image using Search bar on top of Docker Desktop tool.
* Pick any search result and click "Pull" button to download the image to local machine.
* Once downloaded, click on the Run icon to run the container. 
* Note: Expand Optional Settings when you run a new container and configure container details -- like container name, port number etc.
* You may stop the container and exit the Docker Desktop once you're done with the container. 

## Run Container Via Docker CLI
* Go to Docker Hub and search for any image, say "postgres". https://hub.docker.com/search?q=postgres
* Pick appropriate image from the list. https://hub.docker.com/_/postgres.
* In the Image Overview page, click on Copy command to copy docker "pull" command. "docker pull postgres".
* In your Windows machine, start Docker engine, if not running already.
* Then launch Windows PowerShell and paste the copied docker command. This will download the image to your local machine.
* You can validate image status either via Docker Desktop or CLI.
* Start container from Docker Desktop or CLI.
* Stop the container.

## Docker Commands
| Command                                                                                                      | Description                                                                                                                                                                                                                                    |
|--------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| docker login -u [username]                                                                                   | Log in to a registry using your Docker Hub login.                                                                                                                                                                                              |
| docker logout                                                                                                | Log out of the registry.                                                                                                                                                                                                                       |
| docker version                                                                                               | Outputs the version numbers of Docker component                                                                                                                                                                                                |
| docker --version                                                                                             | Outputs the version number of the Docker CLI you are using                                                                                                                                                                                     |
| docker system info [OPTIONS]                                                                                 | This command displays system wide information regarding the Docker installation. Information displayed includes the kernel version, number of containers and images. <br/> Equivalent commands: <br/> * docker system info <br/> * docker info |
| docker image build [OPTIONS] PATH \| URL \| -                                                                | The docker build command builds Docker images from a Dockerfile and a "context". A build's context is the set of files located in the specified PATH or URL. The build process can refer to any of the files in the context.                   |
| * docker image build <br/> * docker build <br/> * docker buildx build <br/> * docker builder build           | docker image build -- Equivalent Commands                                                                                                                                                                                                      |
| docker build https://github.com/docker/rootfs.git#container:docker                                           | When the URL parameter points to the location of a Git repository, the repository acts as the build context. The system recursively fetches the repository and its submodules.                                                                 |
| docker image pull [OPTIONS] NAME[:TAG\|@DIGEST] <br/> docker image pull debian                               | Download an image from a registry. <br/>  This command pulls the debian:latest image as no tag is provided.                                                                                                                                    | Download an image from a registry |
| docker image push [container_registry/username:tag] <br/> docker image push myrepo/cards:s04                 | Command to push image to remote repo “\<namespace>/\<repo>:\<tagname>”                                                                                                                                                                         | 
| docker image ls [OPTIONS] [REPOSITORY[:TAG]]                                                                 | List images. <br/> The default docker images command will show all top level images, their repository and tags, and their size. <br/> Equivalent commands: <br/> * docker image ls <br/> * docker image list <br/> * docker images             |
| docker images java:8                                                                                         | Command to find all local images in the java repository with tag 8                                                                                                                                                                             |
| docker image inspect <IMAGE_ID>                                                                              | Displays details about the image                                                                                                                                                                                                               |
| docker history \<image-name>                                                                                 | Displays intermediate layers and commands that were executed while building the image                                                                                                                                                          |
| docker image tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG] <br/> docker tag 0e5574283393 fedora/httpd:version1.0 | Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE                                                                                                                                                                                          |
| docker rmi \<image name_here>                                                                                | Delete an image                                                                                                                                                                                                                                |
| docker image prune                                                                                           | Remove all unused images                                                                                                                                                                                                                       |
| docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]                                                      | The docker run command runs a command in a new container, pulling the image if needed and starting the container.                                                                                                                              |
| docker run --name test -d nginx:alpine                                                                       | This command runs a container named test using the nginx:alpine image in detached mode                                                                                                                                                         |
| docker run -p 127.0.0.1:80:8080/tcp nginx:alpine                                                             | This command binds port 8080 of the container to TCP port 80 on 127.0.0.1 of the host.                                                                                                                                                         |
| docker container start <CONTAINER_ID>                                                                        | Starts a stopped container                                                                                                                                                                                                                     |
| docker container stop <CONTAINER_ID>                                                                         | Stops a running container                                                                                                                                                                                                                      |
| docker container pause <CONTAINER_ID>                                                                        | Pause a container                                                                                                                                                                                                                              |
| docker container unpause <CONTAINER_ID>                                                                      | Unpause a container                                                                                                                                                                                                                            |
| docker container kill <CONTAINER_ID>                                                                         | Kills a running container                                                                                                                                                                                                                      |
| docker container restart <CONTAINER_ID>                                                                      | Restarts one or more containers                                                                                                                                                                                                                |
| docker container ls [OPTIONS]                                                                                | List containers. <br/> Equivalent commands: <br/> * docker container ls <br/> * docker container list <br/> * docker container ps <br/> *  docker ps                                                                                           |
| docker container inspect <CONTAINER_ID>                                                                      | Inspect details of a container                                                                                                                                                                                                                 |
| docker container logs <CONTAINER_ID>                                                                         | Fetch logs of a container                                                                                                                                                                                                                      |
| docker container stats                                                                                       | Displays all container statistics like CPU, memory usage etc.                                                                                                                                                                                  |
| docker ps --all                                                                                              | Lists all containers. <br/> The docker ps command only shows running containers by default. To see all containers, use the --all (or -a) flag                                                                                                  |
| docker ps --size                                                                                             | Displays two different on-disk-sizes (“size” and “virtual size") for each container.                                                                                                                                                           |
| docker ps --filter "label=color=blue"                                                                        | Matches containers with the color label with the blue value.                                                                                                                                                                                   |
| docker ps --filter status=running                                                                            | Filters containers with 'running' status.                                                                                                                                                                                                      |
|                                                                                                              |                                                                                                                                                                                                                                                |
|                                                                                                              |                                                                                                                                                                                                                                                |


## Sample Docker Commands
* Postgresql
  * $ docker pull postgres:latest
  * $ docker run --rm --name postgresql --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=admin --publish 5432:5432 --detach postgres
  * [OR] $ docker run --rm --name pg -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin --p 5432:5432 --d postgres

## Dockerize Spring Boot Application
* [Using Dockerfile | baeldung.com](https://www.baeldung.com/dockerizing-spring-boot-application)
* [Using Google Jib | baeldung.com](https://www.baeldung.com/jib-dockerizing)

## DOCKERFILE Reference
* [Dockerfile reference | Docker Docs](https://docs.docker.com/engine/reference/builder/)
* [Overview of best practices for writing Dockerfiles | Docker Docs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [Layers | Docker Docs](https://docs.docker.com/build/guide/layers/)

## Google Jib Reference
* [Building Java containers with Jib  |  Google Cloud](https://cloud.google.com/java/getting-started/jib)
* [GoogleContainerTools/jib: Build container images for your Java applications. | github.com ](https://github.com/GoogleContainerTools/jib)
* [jib/jib-maven-plugin at master · GoogleContainerTools/jib | github.com ](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin#quickstart)

