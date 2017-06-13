# Tango & JModelica.org Docker image

This repo contains a Dockerfile for a CentOS7-based Docker image with Tango and JModelica.org installed.

## How do I get set up?

### Building

Watch out, building takes time - around 30 minutes. But fortunately, you don't need to do that!

### Running

You can run it with:
```console
docker run --name jmodelica_test -h tango_jmodelica -e TANGO_HOST=tango-dev.cps.uj.edu.pl:10000 ljbd/centos-tango-jmodelica:latest
```

## What's inside
The image is packed with Tango 9.2.5a, PyTango 9.2.1 as well as IPOPT 3.12.8 and the latest version of JModelica.org from SVN.
It uses supervisor to run the following things:

* Starter (with the supplied hostname, centos\_docker\_test in the example)
* TangoTest test\_docker

## Acknowledgements

The whole image was based on Michal Liszcz's [tango-cs-docker](https://github.com/tango-controls/tango-cs-docker).
JModelica.org and IPOPT installation was taken from [Mechatronics3D](https://github.com/Mechatronics3D/) [jjmodelica](https://github.com/Mechatronics3D/jjmodelica) image.
Thanks very much, guys!
