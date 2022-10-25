###Aliases
#Status
alias gs="git status"
#Push
alias gps="git push"
#Pull
alias gpl="git pull"
#Commit all
alias gca="git commit -am"
#Amend
alias amend="git commit --amend --no-edit"
alias clean="cleanAllRepos && pullAllQuantRepos master && pruneAllRepos force"

###GIT config
git config --global alias.lg             "log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cd)%Creset' --date=relative"
git config --global alias.co             "checkout"
git config --global alias.cob            "checkout -b"
git config --global alias.mc             "mergetool"
git config --global alias.ca		 "clean -xf -e \*.idea -e \*.iml ."
git config --global core.editor          "nano"
git config --global merge.tool           "kdiff3"
git config --global mergetool.keepBackup "false"

###Functions
#Pull all repos in repository directory
function pullAllQuantRepos() {
    repos
    find . -mindepth 1 -maxdepth 1 -type d
    for d in `find . -mindepth 1 -maxdepth 1 -type d`
    do
	if [ ! -d "$d/.git" ]; then
		continue
	fi
        if [ "$1" = "return" ]
        then
            (
              cd "$d" && \
              echo "Pulling master for \e[30m\e[107m$d\e[0m and returning to branch $(git rev-parse --abbrev-ref HEAD)" && \
              git checkout master && \
              git pull && \
              git checkout -
            )
        elif [ "$1" = "master" ]
        then
            (
              cd "$d" && \
              echo "Pulling master for \e[30m\e[107m$d\e[0m" && \
              git checkout master && \
              git pull
            )
	elif [ -n "$1" ]
	then
	    (
	      cd "$d" && \
	      echo "Pulling $1 for \e[30m\e[107m$d\e[0m" && \
	      git checkout $1 && \
	      git pull
	    )
        else
            (
              cd "$d" && \
              echo "Pulling \e[30m\e[107m$d\e[0m in current branch $(git rev-parse --abbrev-ref HEAD)" && \
              git pull
            )
        fi
    done
}

function pruneAllRepos() {
    repos
    for d in `find . -mindepth 1 -maxdepth 1 -type d`
    do
	if [ ! -d "$d/.git" ]; then
		continue
	fi

        (
        cd "$d" && \
        echo "Pruning \e[30m\e[107m$d\e[0m"
	git remote prune origin

        if [ "$1" = "force" ]
        then
              git branch -vv|grep 'origin/.*: gone]'|awk '{print $1}'|xargs git branch -D
        else
              git branch -vv|grep 'origin/.*: gone]'|awk '{print $1}'|xargs git branch -d
        fi
        )
    done
}

function cleanAllRepos() {
    repos
    for d in `find . -mindepth 1 -maxdepth 1 -type d`
    do
	if [ ! -d "$d/.git" ]; then
		continue
	fi

        (
        cd "$d" && \
        echo "Cleaning \e[30m\e[107m$d\e[0m"
        git checkout .
        )
    done
}

function goToMaster() {
    repos
    for d in `find . -mindepth 1 -maxdepth 1 -type d`
    do
	if [ ! -d "$d/.git" ]; then
		continue
	fi

        (
        cd "$d" && \
        echo "Checking out master for \e[30m\e[107m$d\e[0m"
        git checkout master
        )
    done
}
