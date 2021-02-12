red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
bgblack=`tput setab 0`
reset=`tput sgr0`

read -s -p "What branch do you want to pull your repo from github?" branch

echo '
__   _____________  ___ _____ _____  ______  ___  ___  _   _ _____ _____ ___  
| | | | ___ |  _  \/ _ |_   _|  ___| |  _  \|_  |/ _ \| \ | |  __ |  _  |__ \ 
| | | | |_/ | | | / /_\ \| | | |__   | | | |  | / /_\ |  \| | |  \| | | |  ) |
| | | |  __/| | | |  _  || | |  __|  | | | |  | |  _  | . ` | | __| | | | / / 
| |_| | |   | |/ /| | | || | | |___  | |/ /\__/ | | | | |\  | |_\ \ \_/ /|_|  
 \___/\_|   |___/ \_| |_/\_/ \____/  |___/\____/\_| |_\_| \_/\____/\___/ ( )
'


read  -p "${red}${bgblack}$(tput bold)
*****************************************************************************
*                          PODUCTION DJANGO SERVER UPDATE                   *
*---------------------------------------------------------------------------*${yellow}
* THIS SCRIPT WILL:                                                         *
* - Stop the currently running django server (if running)                   *
* - Check for new changes on the ${branch} branch                           *
* - Pull the latest changes and merge them                                  *
* - Install pip packages specified in requirements.txt                      *
* - Check for and apply migrations (optional)                               *
* - Restart the django server (optional)                                    *
*                                                                           *
*                                                                           *           
*****************************************************************************${reset}
Do you want to continue?
" prompt
if [[ $prompt =~ [yY](es)* ]]
        then


echo "${bgblack}${yellow}$(tput bold)
*****************************************************************************
*                    STOPPING DJANGO SERVER (runserver)                     *
*****************************************************************************${reset}
"
        sudo supervisorctl stop all

echo "
*****************************************************************************
*                    Pull Latest Changes ${branch}                          *
*****************************************************************************
"
        cd ~/MySite && git reset --hard HEAD && git fetch && git checkout ${branch}
        cd ~/MySite && git pull origin ${branch}

echo "
*****************************************************************************
*                    Activating Virtual Environment                         *
*****************************************************************************
"
        source /home/ubuntu/MySite/env/django_project/bin/activate

read  -p "${red}${bgblack}$(tput bold)
*****************************************************************************
*                    Do you want to install requirements?                   *
*****************************************************************************${reset}
" prompt
                if [[ $prompt =~ [yY](es)* ]];
                        then

        pip install -r /home/ubuntu/MySite/requirements.txt
                fi

read  -p "${red}${bgblack}$(tput bold)
*****************************************************************************
*                    Do you want to migrate?                                *
*****************************************************************************${reset}
" prompt
                if [[ $prompt =~ [yY](es)* ]];
                        then
                python /home/ubuntu/MySite/manage.py migrate
                fi

echo "
*****************************************************************************
*                    Starting Django Server                                 *
*****************************************************************************
"
        sudo supervisorctl restart all


exit 0

else

echo '
  ___ ______ ___________ _____ _ 
 / _ \| ___ |  _  | ___ |_   _| |
/ /_\ | |_/ | | | | |_/ / | | | |
|  _  | ___ | | | |    /  | | | |
| | | | |_/ \ \_/ | |\ \  | | |_|
\_| |_\____/ \___/\_| \_| \_/ (_)'


echo "$(tput bold)${red}${bgblack}
****************************************************************************
*                                 UPDATE ABORTED                           *
*--------------------------------------------------------------------------*${yellow}
* No changes have been made and the django server should still be running  *
*                                                                          *
* type 'tail -f runserver.log' from the log directory to watch the log     *
****************************************************************************${reset}
"

fi
exit 0
