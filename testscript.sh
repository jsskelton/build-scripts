#!/bin/bash

set -x

REPONAME="https://teamforge/svn/repos/wms_mst/solutions/Proteus"

Component_1="proteus.util proteus.as.util proteus.domain proteus.rs.client proteus.replen.services proteus.core proteus.waveless protreus.storm proteus.services proteus proteus.replen proteus.service"

echo PARAM1=' '
echo CURRENTCOMP=' '
BuildType=trunk
WORKSPACE=`pwd`
REPONAME="https://teamforge/svn/repos/wms_mst/solutions/Proteus"
echo "REPONAME = https://teamforge/svn/repos/wms_mst/solutions/Proteus" > ${WORKSPACE}/${JOBNAME}_ENV.properties

read -a componentarray <<<${Component_1}

for PARAM1 in ${componentarray[@]}
do
    echo ${REPONAME}'/'${PARAM1}'/'${BuildType}
done

