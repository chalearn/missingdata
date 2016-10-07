# missingdata
Research repository for missing data

*************************************************************
*********************** FIRST STEPS *************************
*************************************************************
Please, follow the next command sequence to clone and prepare the repository to work on it for the first time:

	1 - Clone the repository:

		# git clone https://github.com/chalearn/missingdata

	2 - Change the branch to the develop branch (by default the master branch is used):

		# git checkout develop

	3 - Set up your personal configuration (name and email address):

		# git config --global user.email "you@example.com"

		# git config --global user.name "your name"

*************************************************************


*************************************************************
*************** UPLOAD REPOSITORY PROCESS *******************
*************************************************************
To upload your local changes to the GitHub repository follow the next command sequence:

	1 - Previously to the commit step, add the local change files:

		# git add <files to commit>

	If you want to add the changes of a complete folder use:

		# git add <folder name> or 

		# cd <folder name> and # git add .

	2 - Commit the changes to your local repository (add a significant information message about the changes realized):

		# git commit -m "Information message betwenn quotation marks"

	3 - Push the changes to the central repository (in the same branch that you are working):

		# git push

	4 - Push the changes to the master branch. This option will be used only when the developed code works correctly and a final version can be released:

		# git checkout master

		# git merge <branch name>

*************************************************************


*************************************************************
**************** DOWNLOAD REPOSITORY PROCESS ****************
*************************************************************
To download the changes from the GitHub repository to own local copy follow the next command sequence:

	1 - Obtain the GitHub changes:

		# git pull
*************************************************************



*************************************************************
**************** USEFUL EXTRA INFORMATION *******************
*************************************************************
Useful commands to interact with GitHub platform are shown below:

	- Show the status of your local files and check the branch in wich you are working actually:

		# git status

	- Change between diferent branches:

		# git checkout <branch name>

	- Create new branch:

		# git checkout -b <branch name>

	- Delete existing branch:

		# git checkout -d <branch name>

Interesting web about using GitHub and Git:
	
	http://rogerdudler.github.io/git-guide/