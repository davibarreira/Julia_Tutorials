# Mastering Docker

Docker has a client and a server. The docker server
is called the Docker Engine. They communicate via a
REST API.
## Containers Vs. Images

In Docker, an image is described in a `Dockerfile`. It contains
information such as the kernel (you can think of this as the OS)
the installed packages, and so on.
Hence, an image is like the configuration of the machine
where you want to deploy your application.

A container is just an instance of an image, i.e. you can
have many containers running and all of them have the same
underlying configuration. Hence, when we create a `Dockerfile`
and we run a build command from Docker, we are creating an image.

After that, once we do the `docker run my-image` command, we
create a container running with that image.

# FirstDocker

## Creating your own image and running your first container

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

Note that this command will not actually run the container,
but just build it. Run the command `sudo docker images`
to get a list of available images. The `hellodocker`
should be there.

If it's there, then just run `sudo docker run hellodocker`, and
this will run the `hellodocker.jl` script.


## Creating more complicated images

We started with a very simple image. But how do we customize it?
For example, how can we create an image where our Julia environment
is already setup and we can perhaps use a System Image?

First, you might not know what a system image is. Since you are using Julia,
you know that it can take a bit of time to get it to start running, due to
pre-compilation time. We can speed this up with a system image, which is
a binary where we already have all our desired dependencies pre-compiled.
This is great when we want to quickly run some code. The downside is that
the system image can be quite large, and we need to delete it and create
a new one if we wish to update the packages in it.

Yet, if we want to run Julia code in, say, an AWS Lambda function, then
this is a must.

# LambdaDocker

This next example is on how to use Julia with AWS Lambda.
Run the following from within the directory:
```
sudo docker build -t julia-lambda:latest . && sudo docker run -it --rm -p 9000:8080 julia-lambda:latest
```

Wait for 
