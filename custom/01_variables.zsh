###Variables
export JAVA_HOME=/opt/java/current/
export PROJECT_HOME=/data/projects
export QUANT_HOME=$PROJECT_HOME/quant
export DEBUG="-Dmaven.surefire.debug -Dsurefire.timeout=0"
export MAVEN_OPTS="-Xms4g -Xmx4g"
export LESS="$LESS -S"

export PATH=$PATH:/opt/apache/maven/current/bin
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:/opt/node/current/bin

##Node tests
export CHROME_BIN=/usr/bin/chromium
