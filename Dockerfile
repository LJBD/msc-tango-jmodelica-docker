FROM ljbd/solaris-tango-centos:ds-0.4

MAINTAINER ljbdudek@gmail.com

ENV JM_PKGS="Cython subversion java zlib-devel lapack-devel blas-devel gcc-c++ gcc-gfortran cmake swig python2-jpype metis64-devel numpy-f2py wget" \
DL=$HOME/Downloads WS=$HOME/work IPOPT_VER=3.12.8 PATH=/usr/bin:$PATH

# Install required packages
RUN yum --disablerepo=SOL* --disablerepo=max* install -y $JM_PKGS

# Install Ipopt
RUN which wget && mkdir $DL $WS \
&&  wget http://www.coin-or.org/download/source/Ipopt/Ipopt-${IPOPT_VER}.tgz -O $DL/Ipopt-${IPOPT_VER}.tgz
RUN cd $DL && tar -xvf Ipopt-${IPOPT_VER}.tgz \
&&  cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/ \
&& ./ASL/get.ASL \
&& ./Mumps/get.Mumpss
RUN mkdir $DL/Ipopt-${IPOPT_VER}/build && cd $DL/Ipopt-${IPOPT_VER}/build && \
    ../configure --prefix=$WS/Ipopt-${IPOPT_VER} && make install

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
ENV SEPARATE_PROCESS_JVM=/usr/lib/jvm/java-8-openjdk-amd64/

