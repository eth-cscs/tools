#!/usr/local/bin/bash

# Retrieve host name (excluding node number)
hostName=${HOSTNAME//[0-9]/}

# Check host name
case "$hostName" in
  "daint" | "dora" | "santis" | "ela" |"castor" | "pilatus" | "brisi" | "monch" | "eschaln-" | "keschln-" )
  echo
  echo "Configuring EasyBuild on `hostname` ..."
  ;;

  * )
  echo "Not supported host name: ""$hostName"
  exit
esac

# If argument is given, use it as path for easybuild and else use default (/scratch for jenkins or $APPS for the rest)
if [[ -z "$1" ]]; then
    if [[ $USER == "jenscscs" ]] ; then
       if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "brisi" || "$hostName" == "pilatus" || "$hostName" == "monch" ]] ; then
           export PROJ=$SCRATCH"/"$hostName
       elif [[ "$hostName" == "castor" ]] ; then
           export PROJ="/users/jenscscs/sandbox/"$hostName
           export SCRATCH="/tmp"
       elif [[ "$hostName" == "ela" ]] ; then
           export PROJ="/users/jenscscs/sandbox/"$hostName
       elif [[ "$hostName" == "eschaln-" || "$hostName" == "keschln-" ]] ; then
           export PROJ="/lus/scratch/jenscscs/sandbox/"$hostName
       fi
    else # if installing on default apps path, then resulting easyconfig file needs to be pushed to github repository
       export PROJ=$APPS
       if [[ -z "$EASYBUILD_REPOSITORYPATH" ]]; then
           export EASYBUILD_REPOSITORYPATH="git@github.com:eth-cscs/tools.git,easybuild/ebfiles_repo/"$hostName # if using private key
#           export EASYBUILD_REPOSITORYPATH="https://github.com/eth-cscs/tools.git,easybuild/ebfiles_repo/"$hostName # will ask for github password
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
elif [[ "$hostName" == "eschaln-" || "$hostName" == "keschln-" ]] ; then
    source /usr/Modules/3.2.10/init/bash
    export PATH=/usr/Modules/3.2.10/bin/:$PATH
elif [[ "$hostName" == "pilatus" ]] ; then
    export PATH=/usr/share/Modules/tcl/:$PATH
    source /usr/share/Modules/tcl/init/bash
elif [[ "$hostName" == "monch" ]] ; then
    export PATH=/apps/monch/modules/3.2.10/bin/:$PATH
    source /apps/monch/modules/3.2.10/init/bash
elif [[ "$hostName" == "castor" ]] ; then
    export PATH=/apps/castor/Modules/3.2.10/bin/:$PATH
    source /apps/castor/Modules/3.2.10/init/bash
elif [[ "$hostName" == "ela" ]] ; then
    export PATH=/usr/share/Modules/tcl/:$PATH
fi

# Set EasyBuild variables
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "castor" || "$hostName" == "brisi" || "$hostName" == "monch" || "$hostName" == "eschaln-" || "$hostName" == "keschln-" ]] ; then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesC
elif [[ "$hostName" == "ela" || "$hostName" == "pilatus" ]] ; then
    export EASYBUILD_MODULES_TOOL=EnvironmentModulesTcl
fi

export EASYBUILD_PREFIX=${PROJ}/easybuild
export EASYBUILD_SET_GID_BIT=1
export EASYBUILD_GROUP_WRITABLE_INSTALLDIR=1
#export EASYBUILD_STICKY_BIT=1
export EASYBUILD_UMASK=002
export EASYBUILD_BUILDPATH=/dev/shm/$USER
export EASYBUILD_ROBOT_PATHS=/apps/common/easybuild/ebfiles_repo/${hostName}:/apps/common/easybuild/cscs_easyconfigs/:
export EASYBUILD_IGNORE_OSDEPS=0

# Set up private repository for jenkins user (it doesnt belong to csstaff group, it is not supposed to write under /apps/common)
if [[ $USER == "jenscscs" ]] ; then
    export EASYBUILD_SOURCEPATH=$SCRATCH/sources/
else
    export EASYBUILD_SOURCEPATH=/apps/common/easybuild/sources/
fi

if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "brisi" ]] ; then
    export EASYBUILD_EXTERNAL_MODULES_METADATA=/apps/common/easybuild/cray_external_modules_metadata.cfg
    export EASYBUILD_EXPERIMENTAL=1
    export EASYBUILD_OPTARCH=$CRAY_CPU_TARGET
    export CRAYPE_LINK_TYPE=dynamic
#    echo "Purging modules..."
#    module purge
    module switch PrgEnv-cray PrgEnv-gnu
fi

# /apps/common = custom cscs easyblocks
export PYTHONPATH=$PYTHONPATH:/apps/common:/apps/common/gitpython/lib/python2.7/site-packages/
env | grep EASYBUILD
echo PYTHONPATH=$PYTHONPATH
#echo PATH=$PATH

echo "Updating \$MODULEPATH..."
mkdir -p $EASYBUILD_PREFIX/modules/all
module use $EASYBUILD_PREFIX/modules/all
echo MODULEPATH=$MODULEPATH

echo "Loading EasyBuild..."
module load /apps/common/easybuild/modules/all/EasyBuild/2.3.0
