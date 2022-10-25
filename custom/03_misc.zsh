###ALIASES
alias ll='ls -lah'
alias lh='ls -Ad'
alias colordiff='diff --color'
alias shutdown="sudo /usr/sbin/shutdown"
alias bounce="shutdown -r now"
alias open="xdg-open"
alias specs='inxi -Fxz'
alias wally="/opt/ergodox/wally"

alias .......="...... && .."
alias ........="...... && ..."
alias .........="...... && ...."
alias ..........="...... && ....."
alias ...........="...... && ......"

alias con="bluetoothctl connect D8:E0:E1:12:5F:F9"
alias atom="flatpak run io.atom.Atom"

alias java8="(cd /opt/java && ln -snf jdk8 current)"
alias java11="(cd /opt/java && ln -snf jdk11 current)"
alias java17="(cd /opt/java && ln -snf jdk17 current)"

alias debug-zsh="zsh -xvic exit &> omz.log"

###FUNCTIONS
function lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

function upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

function readme() {
  themes=(
    "587.8716"
    "880.1331"
    "630.2337"
  )

  mdv -t ${themes[$RANDOM % ${#themes[@]}+1]} ${1:-README.md}
}
function set-title() {
  echo -n "\e]0;$1\a"
}

function set-title-reactive() {
  while true
  do
    sleep 1
    set-title "$(awk '/\[INFO] Building .* \[[0-9]/{$1=""; a=$0}  END{print a}' $1) - $2"
    if [ ! -f $1 ]
    then
      break
    fi
  done
}

function reset-title() {
  set-title $(pwd)
}

function threeBlankLines() {
  echo;echo;echo
}

function checkExitCode() {
  if [ "$1" -ne "0" ]; then
    return -1
  fi
}

function setTrap() {
  trap 'trap - SIGINT EXIT && pkill -s 0' SIGINT SIGTERM EXIT
}

function unsetTrap() {
  trap - SIGINT EXIT
  pkill -s 0
}

function multikill() {
  kill -9 $(ps aux|grep $1|grep -v grep|awk '{print $2}')
}
function whoIsUsingMySwap(){
    find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable \
    -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END \
    {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]/1024}' '{}' \;\
    | awk '{print $(NF-1),$0}' | sort -h | cut -d " " -f2-
}

function processesUsingSwap(){
    ps o user,pid,%cpu,%mem,start,time,command -p ${$(whoIsUsingMySwap| awk -vORS=, '{print $1}')%?}
}

function repeat-command(){
    repeat_time=$1
    log_one=$2
    log_two=$3
    module=$4

    if [ -z $log_one ];then
       log_one=$(ls -t /tmp/*maven* | head -2 | tail -1)
       log_two=$(ls -t /tmp/*maven* | head -1)
    fi

    if [ -z $log_two ];then
	     log_two=$(ls -t /tmp/*maven* | head -2 | tail -1)
    fi

    if [ -z $repeat_time ] || [ -z $log_one ] || [ -z $log_two ];then
	echo "First parameter 'repeat_time' must be provided"
	echo "Second parameter 'log_one' must be provided"
	echo "Third parameter 'log_two' must be provided"
	return -1
    fi

    if [ -z $module ];then
         module="mdm"
    fi

    total_tests=0
    total_classes=0
    completed_tests=0
    completed_classes=0
    start=0
    now=0
    dur=0
    prev=$(grep "Total time:" $log_one|awk '{print ""$4" "$5""}')
    failures=0
    skipped=0

    while clear;
    do
      	echo "Log files"
      	echo "  $log_one"
      	echo "  $log_two"
      	echo
      	echo "Previous total time: $prev"
      	echo "Duration from first timestamp: $dur min"
              echo
              echo "Total:     tests -> $total_tests  classes -> $total_classes"
              echo "Completed: tests -> $completed_tests  classes -> $completed_classes"
      	if [ $failures -gt 0 ]; then
                  echo "\e[41mTotal failed tests: $failures \e[49m"
      	else
      	    echo "Total failed tests: $failures"
      	fi
      	if [ $skipped -gt 0 ]; then
                  echo "\e[43;30mTotal skipped tests: $skipped \e[49;39m"
      	else
      	    echo "Total skipped tests: $skipped"
      	fi

              sleep $repeat_time

        cip_total_tests=$(grep -E "Testing:" $log_one|wc -l)
        cip_total_classes=$(grep -E "Hung threads count: .* Test case:" $log_one|awk '{print $4}'|uniq|wc -l)
        cip_completed_tests=$(grep -E "Testing:" $log_two|wc -l)
        cip_completed_classes=$(grep -E "Hung threads count: .* Test case:" $log_two|awk '{print $4}'|uniq|wc -l)

        mdm_total_tests=$(grep -E "TestNGLoggingListener - Running test" $log_one|wc -l)
        mdm_total_classes=$(grep -E "TestNGLoggingListener - Test .* |" $log_one|awk '{print $4}'|uniq|wc -l)
        mdm_completed_tests=$(grep -E "TestNGLoggingListener - Running test" $log_two|wc -l)
        mdm_completed_classes=$(grep -E "TestNGLoggingListener - Test .* |" $log_two|awk '{print $4}'|uniq|wc -l)

      	qc_ctm_total_tests=$(grep -E "completed successfully in .* ms" $log_one|wc -l)
      	qc_ctm_completed_tests=$(grep -E "completed successfully in .* ms" $log_two|wc -l)
      	qc_ctm_total_classes=$(grep -E "Running test: .*" $log_one|awk '{print $8}'|cut -d'.' -f 1|sort -u|wc -l)
      	qc_ctm_completed_classes=$(grep -E "Running test: .*" $log_two|awk '{print $8}'|cut -d'.' -f 1|sort -u|wc -l)

      	total_tests=$(echo "$cip_total_tests+$qc_ctm_total_tests+$mdm_total_tests"|bc)
      	total_classes=$(echo "$cip_total_classes+$qc_ctm_total_classes+$mdm_total_classes"|bc)
      	completed_tests=$(echo "$cip_completed_tests+$qc_ctm_completed_tests+$mdm_completed_tests"|bc)
      	completed_classes=$(echo "$cip_completed_classes+$qc_ctm_completed_classes+$mdm_completed_classes"|bc)

        start=$(grep -E "^[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}" $log_two|head -1|awk '{print $1}')
        if [ -n "$start" ];then
        start=${start:0:-4}
	fi
	start=$(date +%s -d ${start})
	now=$(date -u +%s)

	dur=$(expr ${now} - ${start})
	dur=$(date +%M:%S -ud @${dur})

	failures=$(grep -E "failed. Spent .* ms" $log_two|wc -l)
	skipped=$(grep -E 'TestNGLoggingListener - .* skipped' $log_two|wc -l)

    done
}

function finished-builds(){
    echo "Success: $(grep 'BUILD SUCCESS' /tmp/*$1*.log|wc -l)"
    echo "Failures: $(grep 'BUILD FAILURE' /tmp/*$1*.log|wc -l)"
}

function hide-dock() {
  gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
  gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
}

function show-dock() {
  gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
  gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
  gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
}
