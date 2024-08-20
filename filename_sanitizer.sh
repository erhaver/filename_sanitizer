#!/bin/sh
scriptname=$(basename "$0")
ls -A --ignore="$scriptname" > lsfile.txt
declare -A filenumber

#read output of ls to a file called lsfile and parse it 

cat lsfile.txt | while read filename;
    do
    #checks if it is file. In case of directory, goes to next filename
    if [ ! -f "$filename" ]; then
        echo "NOT A FILE : $filename" 
        continue
    fi	
    dot="."
    extension=$([[ "$filename" == *$dot* ]] && echo "${filename##*.}" || echo '')
   
    #tr is used to make the filenames web safe
    mod=`echo "$filename" | sed -e 's/\(.*\)/\L\1/' | tr ' ' '-' | tr '_' '-'`
    #handling filenames which get truncated to special names like '.', '..' or ''(empty filename)
    if [[ $mod == "" || $mod == "." || $mod == ".." ]];then
	   mod="1"
    fi 

    if [ "$mod" != "$filename" ]; then	
	if [[ -e $mod ]]; then
	        dyn_filename=$mod	
		#handling a case where same filenames can be obtained after truncating.
		#dictionary is used to keep track of filenames and their count	
		while true; do
			if [[ -e $dyn_filename ]]; then
				if [[ ${filenumber[$mod]} ]];then
			            count=filenumber[$mod]
				    count=$(( count + 1 )) 
				    filenumber[$mod]=$count 
				else
				   filenumber[$mod]=1
				   count=1

				fi
                                ext=$([[ "$mod" == *$dot* ]] && echo "${mod##*.}" || echo '')
				filename_portion=${mod%.$ext}
				#private file or dot at beginning of file
				if [[ $mod == ".${ext}" ]];then
                                   	string=".${ext}$count"
				#no extension with dot at end
				elif [[ $ext == "" && "$mod" == *$dot* ]]; then
					string="$filename_portion$count."
			        #no extension without dot
				elif [[ $ext == "" ]]; then
					string="$filename_portion$count"

				else
					string="$filename_portion$count.$ext"
				fi
				dyn_filename=$string
			else

				mv  "$filename" "$dyn_filename"
				exit="$?"
				#error handling for mv command
	     			if [ "$exit" == "1" ]; then
	    	    			 echo "ERROR: mv could not be successful for filename $filename exit code:  $exit"
                	 		 exit 125
             			fi

                                echo "updated  $filename to $dyn_filename"
				break
	                fi	
	        done
                		
             
	else
	     #if file does not exist, direct rename
	     mv  "$filename" "$mod"
	     exit="$?"
	     if [ "$exit" == "1" ]; then
	         echo "ERROR: mv could not be successful for filename $filename exit code:  $exit"
                 exit 125
             fi
	     
             echo "updated: $filename to $mod"
         
        fi
       
    fi
    
    done
#removing the lsfile created for this script
rm lsfile.txt
