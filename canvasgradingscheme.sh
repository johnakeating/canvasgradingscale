#!/bin/bash

### Download Courses1



echo "Start!"


token = "<INSERTCANVAS TOKEN>"


while read -r line; do



echo ###### CHECKING COURSE $line #############



sleep 2

response=$(curl https://cuhsd.instructure.com/api/v1/courses/$line -H 'Authorization: Bearer $token')
echo $response

GSSTATUS=`echo $response | grep "grading_standard_id\":null" | wc -l | awk '{$1=$1};1'`
echo $GSSTATUS
	if [ "$GSSTATUS" = "1" ]; then
		echo "#### GRADING SCALE IS NULL --- UPDATING Grading_Standard_Id"
		curl "https://cuhsd.instructure.com/api/v1/courses/$line" -X PUT -H 'Authorization: Bearer $token' -d course[grading_standard_enabled]=true -d course[grading_standard_id]=763
	fi


 	if [ "$GSSTATUS" = "0" ]; then
	echo CHECKING TO SEE WHAT SCALE IS APPLIED
	FIND_SCALE=`echo $response | grep "grading_standard_id\":763" | wc -l | awk '{$1=$1};1'`

		if [ "$FIND_SCALE" = "0" ]; then
			
		echo $line >> canvaslog.txt
		echo RANDO Grading Scale
		else
		echo Standard Grading Scale SET

	fi


	fi
echo #### NO UPDATE NEEDED

	
done <courses.txt
