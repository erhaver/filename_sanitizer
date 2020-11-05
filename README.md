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


Implementation of the 3rd possibility:
The dictionary called filenumbers maintains key as filename to their count as value. Every time a filename is modified, we check if it exists. If it does not exist, then it is directly renamed.
If it exists, then we increment the count. For example, after truncating, abcd.jpg is encountered a second time, so it will rename it as abcd1.jpg and store in dictionary as “abcd.jpg”:1 When it is encountered for third time, we take out the value for “abcd.jpg” from dictionary and add 1. So, for this, the value for abcd.jpg will be 2 and hence, file is renamed as abcd2.jpg. Then the pair abcd.txt:2 is stored in dictionary and it goes on like this. We do this till the filename is unique.
In this situation, I do the renaming based on if it is a private file, file with no extension with dot at end (required for not generating invalid extensions), file with no extensions and no dots or file with usual format: filename.ext. So, a private file: .image and .imag#e will be renamed as .image and .image1.
A file named resume one, res@ume one will be renamed as resume_one, resume_one1.
Finally I put an error handling to mv command used for renaming. In case, mv is restricted an error is thrown.
At end of script, lsfile.txt is deleted.


