# KernelHaven-Docker

This is a docker container that simplifies working with the KernelHaven-Infrastructure on different operating systems.

You can place your working files within the directory on your host machine that you mapped to the containers ```/data``` folder.

## Configuration Options

This container assumes a file named ```configuration.properties``` to exist within that same folder which defines the settings for the execution of KernelHaven.

This container may be configured to automatically download the newest versions of KernelHaven and its plugins. Configuration for updates happens through the files ```autoupdate-root.txt``` and ```autoupdate-plugins.txt```. In there simply list the URLs from which you  wish to download files to the root folder (```/data``` - usually this will be  ```KernelHaven.jar``` only) or the plugins-folder (```/data/plugins``` - usually those files will be plugins only). If a file with the same name as the remote file already exists, the download only happens if the file on the remote location has changed. You can deactivate single lines by prepending a ```#```-symbol.

If the files ```autoupdate-root.txt``` and ```autoupdate-plugins.txt``` are missing when the container is started, default versions will be copied into the ```/data```-folder.


## Getting it running

Prerequisites: [install docker](https://docs.docker.com/engine/installation/)

Initially you will have to run

```
docker run --memory=64G -v /path/on/host:/data --name kernelhaven moritzf/kernelhaven:latest
```
(Replace ```--memory=64G``` with your desired memory limit for the container)

(Replace ```/path/on/host``` with valid path on your host machine)

Any subsequent runs can be started with the following command:

```
docker start --attach kernelhaven
```

## Updating the Container-Image

*Note: this is only needed if you want to update the Docker image. This is not neccessary for updating KernelHaven or its plugins*

First remove the container

```
docker rm kernelhaven
```

Then remove the container image

```
docker rmi moritzf/kernelhaven:latest
```

Then repeat the steps for "Getting it Running" again.
