# Tango & JModelica.org Docker image

This repo contains a Dockerfile for a CentOS7-based Docker image with Tango and JModelica.org installed.

## How do I set it up?

### Building

Watch out, building takes time - around 30 minutes. But fortunately, you don't need to do that!
If you're really convinced to do so, you must ensure that you have access to `ljbd/solaris-tango-centos` image from DockerHub.

### Running

You can run it with the following command, if you don't mind the X security:
```console
docker run --name jmodelica_test -h tango_jmodelica -e TANGO_HOST=tango-dev.cps.uj.edu.pl:10000 -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix -v $PROJECTS/masthe-tango-ds-tanks-regulation/:$PROJECTS/masthe-tango-ds-tanks-regulation ljbd/centos-tango-jmodelica:0.4

```

## What's inside?
The image is packed with Tango 9.2.5a, PyTango 9.2.1 as well as IPOPT 3.12.8 and the latest version of JModelica.org from SVN.
It uses supervisor to run the following things:

* Starter (with the supplied hostname, centos\_docker\_test in the example)
* TangoTest test\_docker

## Acknowledgements

The whole image was based on Michal Liszcz's [tango-cs-docker](https://github.com/tango-controls/tango-cs-docker).
JModelica.org and IPOPT installation was taken from [Mechatronics3D](https://github.com/Mechatronics3D/) [jjmodelica](https://github.com/Mechatronics3D/jjmodelica) image.
Transferring X-server to your own machine was taken from [cpascual](https://github.com/cpascual)'s [taurus-test](https://github.com/cpascual/taurus-test) image.
Thanks very much, guys!
