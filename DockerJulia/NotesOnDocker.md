# Mastering Docker

Docker has a client and a server. The docker server
is called the Docker Engine. They communicate via a
REST API.

The information regarding containers are inside a `Dockerfile`.
We start specifying the image we'll use. We can use pre-set
images from Docker-Hub. This can ease the process of installing different packages.

The folder `FirstDocker` has an example of a very simple
container that run a julia script.

Here is the content of the dockerfile in this folder:
```
FROM julia:1.6.7-alpine
COPY . ./app
WORKDIR /app
CMD julia hellodocker.jl
```

The first line is specifying that we are going to use the
container `julia` from Docker Hub, with version 1.6.7, which is
the current stable version. The `alpine` is a Linux distro
that is very lightweight, and hence good for keeping
containers small.

Next, the `COPY . ./app` is copying everything in the current
where the Dockerfile is, and is saving these files inside a folder
called `app/`. The following line is setting the `/app` folder
as the working directory.

The last line is declaring what command should be ran when we build
this container. Thus, once we run the container, it will
always start by running the `hellodocker.jl` script.

Go inside the `FirstDocker` folder and run the following:
```
sudo docker build -t hellodocker .
```

This command will build a docker image with the name `hellodocker`.
Note that the `.` in the end of the command specifies where the
Dockerfile is.

Note that this command will note actually run the container,
but just build it. Run the command `sudo docker images`
to get a list of available images. The `hellodocker`
should be there.

If it's there, then just run `sudo docker run hellodocker`, and
this will run the `hellodocker.jl` script.
