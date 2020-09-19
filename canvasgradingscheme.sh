#!/bin/bash

#### ENTER YOUR CANVAS SETTINGS HERE

### SET Canvas URL IE XXX.instructure.com
canvasurl="<INSERTCANVAS URL>"
### SET AUTH TOKEN https://community.canvaslms.com/t5/Admin-Guide/How-do-I-manage-API-access-tokens-as-an-admin/ta-p/89
token="<INSERTCANVAS TOKEN>"
### SET THE GRADING SCALE FOR CLASSES THAT DO NOT HAVE ONE APPLIED. 
default_grading_scale_id="<INSERTCANVAS SCHEME>"





### Download Courses1
##This section still needs to be created. 


echo "Start!"




while read -r line; do



echo ###### CHECKING COURSE $line #############



sleep 2

response=$(curl https://$canvasurl/api/v1/courses/$line -H 'Authorization: Bearer '$token'')
echo $response

GSSTATUS=`echo $response | grep "grading_standard_id\":null" | wc -l | awk '{$1=$1};1'`
echo $GSSTATUS
        if [ "$GSSTATUS" = "1" ]; then
                echo "#### GRADING SCALE IS NULL --- UPDATING Grading_Standard_Id"
                curl "https://$canvasurl/api/v1/courses/$line" -X PUT -H 'Authorization: Bearer '$token'' -d course[grading_standard_enabled]=true -d course[grading_standard_id]=$default_grading_scale_id
        fi


        if [ "$GSSTATUS" = "0" ]; then
        echo CHECKING TO SEE WHAT SCALE IS APPLIED
        FIND_SCALE=`echo $response | grep "grading_standard_id\":$default_grading_scale_id" | wc -l | awk '{$1=$1};1'`

                if [ "$FIND_SCALE" = "0" ]; then

                echo $line >> canvaslog.txt
                echo RANDO Grading Scale
                else
                echo Standard Grading Scale SET

        fi


        fi
echo #### NO UPDATE NEEDED


done <courses.txt

