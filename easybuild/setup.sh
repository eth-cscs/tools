#!/usr/local/bin/bash

# Retrieve host name (excluding node number)
hostName=${HOSTNAME//[0-9]/}

# Check host name
if [[ "$hostName" != "daint" && "$hostName" != "dora" && "$hostName" != "santis" && "$hostName" != "ela" && "$hostName" != "castor" && "$hostName" != "pilatus" && "$hostName" != "brisi" ]] ; then
    errorMessage="Not supported host name :""$hostName"
    echo $errorMessage
    exit
fi

# If argument is given, use it as path for easybuild and else use default (/scratch for jenkins or $APPS for the rest)
if [[ -z "$1" ]]; then
    if [[ $USER == "jenscscs" ]] ; then
       export PROJ="/scratch/daint/jenscscs/"$hostName
    else # if installing on default apps path, then resulting easyconfig file needs to be pushed to git repository
       export PROJ=$APPS
#       export EASYBUILD_REPOSITORYPATH="git@github.com:eth-cscs/tools.git,easybuild/ebfiles_repo/"$hostName # if using private key
       if [[ -z "$EASYBUILD_REPOSITORYPATH" ]]; then
           export EASYBUILD_REPOSITORYPATH="https://github.com/eth-cscs/tools.git,easybuild/ebfiles_repo/"$hostName
       fi
       export EASYBUILD_REPOSITORY=GitRepository
    fi
else
    export PROJ=${1}
    export EASYBUILD_REPOSITORYPATH=${1}/easybuild/ebfiles_repo/
    export EASYBUILD_REPOSITORY=FileRepository
fi

# Switch environment modules (set PATH varible)
echo "Switching to environment modules ..."
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "brisi" ]] ; then
    source /opt/modules/3.2.10.3/init/bash
    export PATH=/opt/modules/3.2.10.3/bin/:$PATH
elif [[ "$hostName" == "castor" ]] ; then
    export PATH=$PROJ/Modules/$MODULE_VERSION/bin:$PATH
else #pilatus
    export PATH=/usr/share/Modules/tcl/:$PATH
fi

# Set EasyBuild variables
echo "Configuring EasyBuild on `hostname` ..."
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "castor" || "$hostName" == "brisi" ]] ; then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesC
elif [[ "$hostName" == "ela" || "$hostName" == "pilatus" ]] ; then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesTcl
fi

export EASYBUILD_PREFIX=${PROJ}/easybuild
export EASYBUILD_SET_GID_BIT=1
#export EASYBUILD_STICKY_BIT=1
export EASYBUILD_UMASK=002
export EASYBUILD_BUILDPATH=/dev/shm/$USER
export EASYBUILD_ROBOT_PATHS=/apps/common/easybuild/cscs_easyconfigs/:
export EASYBUILD_IGNORE_OSDEPS=0

if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "brisi" ]] ; then
    export EASYBUILD_EXTERNAL_MODULES_METADATA=/apps/common/easybuild/cray_external_modules_metadata.cfg
    export EASYBUILD_EXPERIMENTAL=1
    export EASYBUILD_OPTARCH=$CRAY_CPU_TARGET
    echo "Purging modules..."
#    module purge
    module switch PrgEnv-cray PrgEnv-gnu
fi

# /apps/common = custom cscs easyblocks
export PYTHONPATH=$PYTHONPATH:/apps/common:/apps/common/gitpython/lib/python2.7/site-packages/
env | grep EASYBUILD
echo PYTHONPATH=$PYTHONPATH

echo "Updating \$MODULEPATH..."
mkdir -p $EASYBUILD_PREFIX/modules/all
module use $EASYBUILD_PREFIX/modules/all

echo "Loading EasyBuild..."
module load /apps/common/easybuild/modules/all/EasyBuild/2.1.1
