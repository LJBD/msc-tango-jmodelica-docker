FROM ljbd/solaris-tango-centos:ds-0.4

MAINTAINER ljbdudek@gmail.com

ENV JM_PKGS="Cython subversion java python-devel python-svn python-lxml python-nose zlib-devel lapack-devel blas-devel"
ENV DL=$HOME/Downloads
ENV WS=$HOME/work
ENV IPOPT_VER=3.12.8

# Install required packages
RUN yum install -y $JM_PKGS

# Install Ipopt
RUN mkdir $DL
RUN wget http://www.coin-or.org/download/source/Ipopt/Ipopt-${IPOPT_VER}.tgz -O $DL/Ipopt-${IPOPT_VER}.tgz
RUN cd $DL && \
    tar -xvf Ipopt-${IPOPT_VER}.tgz
RUN cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/ASL && ./get.ASL
RUN cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/Blas && ./get.Blas
RUN cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/Lapack && ./get.Lapack
RUN cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/Mumps && ./get.Mumps
RUN cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/Metis && ./get.Metis
RUN mkdir $DL/Ipopt-${IPOPT_VER}/build
RUN cd $DL/Ipopt-${IPOPT_VER}/build && \
    ../configure --prefix=$WS/Ipopt-${IPOPT_VER}
RUN cd $DL/Ipopt-${IPOPT_VER}/build && make install

# Install JModelica
RUN cd $DL && mkdir JModelica.org && \ 
    svn co https://svn.jmodelica.org/trunk $DL/JModelica.org
RUN cd $DL/JModelica.org && \
    mkdir build && \
    cd build && \
    ../configure --prefix=$WS/JModelica.org \
             --with-ipopt=$WS/Ipopt-3.12.7 && \
    make install && \
    make casadi_interface

# Define environment variables for JModelica
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
ENV JMODELICA_HOME=$WS/JModelica.org
ENV CPPAD_HOME=$JMODELICA_HOME/ThirdParty/CppAD/
ENV SUNDIALS_HOME=$JMODELICA_HOME/ThirdParty/Sundials
ENV PYTHONPATH=:$JMODELICA_HOME/Python::$PYTHONPATH
ENV LD_LIBRARY_PATH=:$IPOPT_HOME/lib/:$SUNDIALS_HOME/lib:$JMODELICA_HOME/ThirdParty/CasADi/lib:$LD_LIBRARY_PATH
ENV SEPARATE_PROCESS_JVM=/usr/lib/jvm/java-7-openjdk-amd64/

RUN chown -R $NB_USER $DL

RUN chown -R $NB_USER $WS

USER $NB_USER

