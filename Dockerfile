FROM ljbd/solaris-tango-centos:ds-0.4

MAINTAINER ljbdudek@gmail.com

ENV DL=$HOME/Downloads WS=$HOME/work IPOPT_VER=3.12.8 PATH=/usr/bin:$PATH

# Install required packages
RUN yum --disablerepo=SOL* --disablerepo=max* install -y Cython subversion java \
	zlib-devel lapack-devel blas-devel gcc-c++ gcc-gfortran cmake swig \
	python2-jpype metis64-devel numpy-f2py wget patch make which ant scipy\
&& JCC_JDK=/usr/lib/java-1.8.0-openjdk pip install jcc

# Install Ipopt
RUN which wget && mkdir $DL $WS \
&& wget http://www.coin-or.org/download/source/Ipopt/Ipopt-${IPOPT_VER}.tgz -O $DL/Ipopt-${IPOPT_VER}.tgz \
&& cd $DL && tar -xvf Ipopt-${IPOPT_VER}.tgz \
&& cd $DL/Ipopt-${IPOPT_VER}/ThirdParty/ \
&& cd ASL && ./get.ASL \
&& cd ../Mumps && ./get.Mumps \
&& cd ../../ && ./configure --prefix=$WS/Ipopt-${IPOPT_VER} && make install && rm -rf $DL/Ipopt-${IPOPT_VER}

# Install JModelica
RUN cd $DL && mkdir JModelica.org && svn co https://svn.jmodelica.org/trunk $DL/JModelica.org \
&& cd $DL/JModelica.org && mkdir build && cd build && \
    ../configure --prefix=$WS/JModelica.org --with-ipopt=$WS/Ipopt-${IPOPT_VER} && \
    make install && make casadi_interface

# Define environment variables for JModelica
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/ JMODELICA_HOME=$WS/JModelica.org CPPAD_HOME=$JMODELICA_HOME/ThirdParty/CppAD/ SUNDIALS_HOME=$JMODELICA_HOME/ThirdParty/Sundials PYTHONPATH=:$JMODELICA_HOME/Python::$PYTHONPATH
ENV LD_LIBRARY_PATH=:$IPOPT_HOME/lib/:$SUNDIALS_HOME/lib:$JMODELICA_HOME/ThirdParty/CasADi/lib:$LD_LIBRARY_PATH
ENV SEPARATE_PROCESS_JVM=$JAVA_HOME

