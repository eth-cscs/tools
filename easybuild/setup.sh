#!/usr/local/bin/bash

# Retrieve host name (excluding node number)
hostName=${HOSTNAME//[0-9]/}

if [[ "$hostName" == "eschaln-" || "$hostName" == "keschln-" ]] ; then
   export APPS=/apps/escha
fi

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
       if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "brisi" || "$hostName" == "pilatus" ]] ; then
           export PROJ=$SCRATCH"/"$hostName
       elif [[ "$hostName" == "monch" ]] ; then
           export PROJ="/mnt/lnec/jenscscs/"$hostName
       elif [[ "$hostName" == "castor" ]] ; then
           export PROJ="/users/jenscscs/sandbox/"$hostName
       elif [[ "$hostName" == "ela" ]] ; then
           export PROJ="/users/jenscscs/sandbox/"$hostName
       fi
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
echo "Configuring EasyBuild on `hostname` ..."
if [[ "$hostName" == "daint" || "$hostName" == "dora" || "$hostName" == "santis" || "$hostName" == "castor" || "$hostName" == "brisi" || "$hostName" == "monch" || "$hostName" == "eschaln-" || "$hostName" == "keschln-" ]] ; then
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
export EASYBUILD_SOURCEPATH=/apps/common/easybuild/sources/

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
echo PATH=$PATH

echo "Updating \$MODULEPATH..."
mkdir -p $EASYBUILD_PREFIX/modules/all
module use $EASYBUILD_PREFIX/modules/all

echo "Loading EasyBuild..."
if [[ $USER == "jenscscs" ]] ; then
   module load /apps/common/easybuild/modules/all/EasyBuild/2.2.0
else
   module load /apps/common/easybuild/modules/all/EasyBuild/2.1.1
fi


