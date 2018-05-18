#!/bin/bash
# deploy.sh - This shell script deploys pickpack application. 
# Author - Subhash Pavuluri

MAX_WAIT=300
DELAY=10
TOTAL_WAIT=0

if [ ! -n "$1" ];
	then
	echo ""
	echo "Please enter zip file name";
	exit 0;
fi;

scripts_home=/apps/scope/mstscripts
echo "Zip file is:: $1"
loc=/apps/scope/deployment/talos
Picking_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-pick/deployments
Packing_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-pack/deployments
HandHeld_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-handheld/deployments
Core_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-coreui/deployments
Print_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-print/deployments
Core_work_jboss=/apps/scope/jboss/WMS_Talos/app/appserver-corework/deployments

result=0
checkStatus (){
echo "checking application status"
check=`ls -l $2/$1.deployed | awk '{print $9}'`
echo ""
until [ $TOTAL_WAIT -gt $MAX_WAIT ]
do
if [ -n "$check" ]
        then
                echo "************ $1 Application deployed successfully ***********.";
		echo ""
		break
        else
		sleep $DELAY
	        let TOTAL_WAIT=$TOTAL_WAIT+$DELAY;
                echo " $1 Application is not deployed .. Please check the logs"
		result=1
 fi
done
}

stopAll () {
echo "Stopping $1"
source /home/wmsadmin/.bash_profile;/apps/scope/mstscripts/stoptalos.sh
sleep 10
}

startAll (){
echo "Starting $1"
source /home/wmsadmin/.bash_profile;/apps/scope/mstscripts/starttalos.sh
}

#stopAll

orig_loc=$loc
mkdir $loc/temp
loc=$loc/temp

cd $loc
unzip -o ../talos.zip 
echo "location is $loc"
dep_pack=0
dep_pack=0
dep_hh=0
coreworkdeploy=0
coredeploy=0
printdeploy=0

	apps=`ls -l *.war | awk '{print $9}'`
	echo ""
	for app in $apps
        do
		echo "App name is::$app::"
		shopt -s nocasematch
		if [[ "$app" == "Picking.war" ]]
        	 then
$scripts_home/appserver-pick.sh stop
			echo "deploying $app to $Picking_jboss"
			sleep 5
			cp $loc/$app $Picking_jboss
			sleep 5
$scripts_home/appserver-pick.sh start
		dep_pick=1
		elif [[ "$app" == "Packing.war" ]]
                 then
$scripts_home/appserver-pack.sh stop
                        echo "deploying $app to $Packing_jboss"
			sleep 5
                        cp $loc/$app $Packing_jboss
$scripts_home/appserver-pack.sh start
			sleep 5
			dep_pack=1
		elif [[ "$app" == "HandHeld.war" ]]
                 then
$scripts_home/appserver-handheld.sh stop
                        echo "deploying $app to $HandHeld_jboss"
			sleep 5
                        cp $loc/$app $HandHeld_jboss
$scripts_home/appserver-handheld.sh start
sleep 5
			dep_hh=1
		elif [[ "$app" == "PrintingFramework-0.9.war" ]]
                then
$scripts_home/appserver-print.sh stop
                        echo "deploying $app to $Print_jboss"
                        sleep 5
                        cp $loc/$app $Print_jboss
$scripts_home/appserver-print.sh start
                        sleep 5
                        printdeploy=1;

		elif [[ "$app" == "GUI.war"  ]]
		then
$scripts_home/appserver-coreui.sh stop
			echo "deploying $app to $Core_jboss"
			sleep 5
                 	cp $loc/$app $Core_jboss
$scripts_home/appserver-coreui.sh start
			sleep 5
			coredeploy=1;
                elif [[ "$app" == "CORE.war"  || "$app" == "Work.war" ]]
                then
$scripts_home/appserver-corework.sh stop
                        echo "deploying $app to $Core_work_jboss"
                        sleep 5
                        cp $loc/$app $Core_work_jboss
$scripts_home/appserver-corework.sh start 
                        sleep 5
                        coreworkdeploy=1;
	
	fi
		shopt -u nocasematch
	done

#startAll
sleep 100
 if [ "$coredeploy" == 1 ]
 then
        cd $Core_jboss
         apps=`ls -l *.war | awk '{print $9}'`

        for app in $apps
        do
                checkStatus $app $Core_jboss
        done
 else
	sleep 200
 fi

sleep 100
 if [ "$coreworkdeploy" == 1 ]
 then
        cd $Core_work_jboss
         apps=`ls -l *.war | awk '{print $9}'`

        for app in $apps
        do
                checkStatus $app $Core_work_jboss
        done
 else
        sleep 200
 fi


sleep 100
 if [ "$printdeploy" == 1 ]
 then
                checkStatus "PrintingFramework-0.9.war" $Print_jboss
 fi
sleep 2

if [ "$dep_pack" == 1 ]
then 
	checkStatus "Picking.war"  $Picking_jboss
fi
sleep 2
if [ "$dep_pick" == 1 ]
then 
	checkStatus "Packing.war" $Packing_jboss
fi
sleep 2
if [ "$dep_hh" == 1 ]
then 
	checkStatus "HandHeld.war" $HandHeld_jboss
 fi

 if [ "$result" == 0 ]
 then 
	echo ""
	echo "Deployment Successfull."
	echo "moving to $orig_loc/installed folder"
        mv $orig_loc/$1 $orig_loc/installed/$1_$(date +"%Y%m%d%H%M")
 fi

 if  [ "$result" == 1 ]
 then 
	echo "One or more applicaitons Failed to Start. Please check logs."
 fi

 echo "Deleting temp folder"
 rm -fr $loc
