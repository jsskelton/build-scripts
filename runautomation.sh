c!/bin/sh
# This script deploys the proteus war files. 
# Export JBOSS HOME
set -x
if [ ! -d '/apps/mst' ]; then
	ln -s /apps/scope mst
fi
ls -latr /apps/mst
cd 
PRODUCT=$1
JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.9.x86_64
MAVEN_HOME=/apps/mst/apache-maven-3.0.5
SonarAppName=${PRODUCT}-functionaltest
FOB=WMS_${PRODUCT}_
stage="_Stage3"
Product=${PRODUCT}
FUNCTIONALTEST=artemis-implementation.zip
SONARRUNNER=/apps/mst/sonarrunner/latest/bin
JOBNAME=${PRODUCT}-functionaltest
PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:/apps/mst/mstscripts:/apps/mst/deployment/artemis-implementation:$PATH
export PRODUCT
export JAVA_HOME
export MAVEN_HOME
export SonarAppName
export FOB
export stage
export Product
export FUNCTIONALTEST
export SONARRUNNER
export JOBNAME
export PATH
sleep 5
# export VERSION=$(echo $V1|cut -d':' -f2)
cd /apps/mst/mstscripts
script_loc=/apps/mst/mstscripts
export script_loc
loc=/apps/mst/deployment
export loc
orig_loc=$loc
export orig_loc
cd $loc
unzip $FUNCTIONALTEST
sleep 20
if [ ! -d '/apps/mst/deployment/artemis-implementation' ] ; then
    mkdir /apps/mst/deployment/artemis-implementation
fi
if [ ! -d '/apps/mst/deployment/artemis-implementation/src' ] ; then
    mkdir /apps/mst/deployment/artemis-implementation/src
fi
if [ ! -d '/apps/mst/deployment/artemis-implementation/src/main' ] ; then
    mkdir /apps/mst/deployment/artemis-implementation/src/main
fi
if [ ! -d '/apps/mst/deployment/artemis-implementation/src/main/java' ] ; then
    mkdir /apps/mst/deployment/artemis-implementation/src/main/java
fi
build_loc=/apps/mst/deployment/artemis-implementation
export build_loc
sleep 10
cd $build_loc
# run maven verify
mvn --version
mvn clean
mvn verify

V1=`grep BuildId.sop BuildId.sop*`
VERSION=$(echo $V1|cut -d'=' -f2|cut -d':' -f2)
export VERSION
sleep 10

cd $script_loc

python $script_loc/jbehave_converter.py -t $build_loc/src/test/java -r $build_loc/target/failsafe-reports -f results.xml

# Sonarrunner placeholders
$SONARRUNNER/sonar-runner -Dsonar.jdbc.username=SOQPA1 -Dsonar.jdbc.password=soqadm1n -Dsonar.projectBaseDir=$build_loc/. -Dsonar.projectKey=${FOB}${SonarAppName}${stage} -Dsonar.projectName=${FOB}${SonarAppName}${stage} -Dsonar.projectVersion=${VERSION} -Dsonar.junit.reportsPath=target/failsafe-reports -Dsonar.sources=src/main/java -Dsonar.tests=$build_loc/src/test/java -Dsonar.genericcoverage.itReportPaths=$build_loc/target/failsafe-reports/results.xml

sleep 10
cd $build_loc
ls -latr
zip -r FTtarget.zip target/* -x "*/\.*" -x "*\udeploy*"
ls -latr
sleep 10
# zip -r SRCtarget.zip src/* -x "*/\.*" -x "*\udeploy*"
# sleep 10

