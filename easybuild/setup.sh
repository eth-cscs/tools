#!/usr/local/bin/bash

# Retrieve host name (excluding node number)
hostName=${HOST//[0-9]/}

# Check host name
if [[ "$hostName" != "daint" && "$hostName" != "dora" && "$hostName" != "santis" && "$hostName" != "ela" && "$hostName" != "castor" && "$hostName" != "pilatus" ]] ; then
    errorMessage="Not supported host name :""$hostName"
    echo $errorMessage
    exit
fi

# If argument is given, use it as path for easybuild and else use default (/scratch for jenkins or $APPS for the rest)
if [[ -z "$1" ]]; then
    if [ $USER == "jenscscs" ] ; then
       export PROJ="/scratch/daint/jenscscs/"$hostName
    else
       export PROJ=$APPS
#       export EASYBUILD_REPOSITORYPATH=/apps/common/tools/,easybuild/ebfiles_repo/
#       export EASYBUILD_REPOSITORY=GitRepository
    fi
else
    export PROJ=${1}
fi

# Switch environment modules (set PATH varible)
echo "Switching to environment modules ..."
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" ]] ; then
    source /opt/modules/3.2.10.3/init/bash
    export PATH=/opt/modules/3.2.10.3/bin/:$PATH
elif ["$hostName" == "castor"]
then
    export PATH=$PROJ/Modules/$MODULE_VERSION/bin:$PATH
else #pilatus
    export PATH=/usr/share/Modules/tcl/:$PATH
fi

# Set EasyBuild variables
echo "Configuring EasyBuild on `hostname` ..."
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "castor" ]] ; then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesC
elif [["$hostName" == "ela" || "$hostName" == "pilatus"]
then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesTcl
fi

export EASYBUILD_PREFIX=${PROJ}/easybuild
export EASYBUILD_BUILDPATH=/dev/shm/$USER
export EASYBUILD_ROBOT_PATHS=/apps/common/easybuild/cscs_easyconfigs/:
export EASYBUILD_IGNORE_OSDEPS=0

if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" ]] ; then
    export EASYBUILD_EXTERNAL_MODULES_METADATA=/apps/common/easybuild/cray_external_modules_metadata.cfg
    export EASYBUILD_EXPERIMENTAL=1
    export EASYBUILD_OPTARCH=$CRAY_CPU_TARGET
    echo "Unloading PrgEnv-cray (temp. workaround)"
    module unload PrgEnv-cray
fi

export PYTHONPATH=$PYTHONPATH:/apps/common/gitpython/lib/python2.7/site-packages/
env | grep EASYBUILD
echo $PYTHONPATH

echo "Updating \$MODULEPATH..."
mkdir -p $EASYBUILD_PREFIX/modules/all
module use $EASYBUILD_PREFIX/modules/all

echo "Loading EasyBuild..."
module load /apps/common/easybuild/modules/all/EasyBuild/2.1.1
