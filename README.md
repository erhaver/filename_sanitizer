# filename_sanitizer
A folder has image files for a webpage. These filenames can have spaces or punctuations. Rename files using bash script so that they are websafe.
Sourik Dhua

Program logic:
First the script copies the “ls -a” output to a file called lsfile.txt
Reason: In Linux, I named some files with spaces. In the script, I used ‘ls -a’ and directly looped through its output to find that filenames with space are treated as different files. So, to prevent, that I am creating this temporary file. Also, this file will be deleted at end of script.
Then to check errors such as invalid extensions(given folder should have web safe image files), the script separates the extension and checks if it is a valid one. I have used an array containing a set of valid extensions. This can be modified as required.
The script allows/processes filenames without extensions and private files(dot at beginning) as well as these are websafe.
Then I have truncated the filenames as required using tr. I made them lowercase and allowed only _ (as we are replacing space by underscore so I am not removing already existing ones)and ‘.’ As dot is required for extensions. Also, spaces are replaced by “_”.
After truncating, if file exists, three possibilities:
1. possibility is to ask user to overwrite but for large files with same truncated name, it is not practical(100 file with same truncated names).
2. This can be solved by asking if the user wants to overwrite all files with same modified names. So, ask the user once. But in this case, we have to create another dictionary which keeps track of yes or no for a particular file. Every time a file is in this case, it checks the dictionary if user had input yes or no and accordingly perform functionality.
3. Keep all of them (no user input) and rename them accordingly. Since, the folder has all image files needed for web page, overwriting might not be required(assuming all images are different), so I went with this.

3rd possibility is implemented in this project
