###Aliases
alias tree="mvn dependency:tree"
alias nodoc="mcist -pl '!doc'"
alias nodoc+="mcist -pl '!doc,!doc/service,!doc/system'"
alias towebapp="nodoc -pl '!app/rio-webapp,!app/rio-integration-test,!app/rio-runner,!msi'"
alias mci11="JAVA_HOME=/opt/java/openjdk/current mci"
alias mcist11="JAVA_HOME=/opt/java/openjdk/current mcist"

###Functions
function treed() {
  mvn dependency:tree -Dincludes=$1
}

function deps() {
  mvn versions:display-dependency-updates |awk '/.*The following dependencies in Dependencies/,/.*---/'|grep -oP '(?<=INFO]  ).*'|awk '!/  /&&NR>1{print OFS}{printf "%s ",$0}END{print OFS}'C|tr -s ' '|grep -v 9999|grep -v 255|sort|uniq
}

function mci() {
  MAVEN_LOG="/tmp/$(date +%Y%m%d%H%M%S)_cleanInstall_maven.log"
	COMMAND="mvn clean install $@"
	echo "Running command: '$COMMAND'"

  setTrap

	set-title-reactive $MAVEN_LOG "-> $(date $DATE_FORMAT) - $COMMAND" &
	eval "$COMMAND" | tee $MAVEN_LOG

  unsetTrap
  reset-title
}

function mcist() {
  MAVEN_LOG="/tmp/$(date +%Y%m%d%H%M%S)_cleanInstallNoTests_maven.log"
	COMMAND="mvn clean install -DskipTests $@"
	echo "Running command: '$COMMAND'"

  setTrap

	set-title-reactive $MAVEN_LOG "-> $(date $DATE_FORMAT) - $COMMAND" &
	eval "$COMMAND" | tee $MAVEN_LOG

  unsetTrap
  reset-title
}
