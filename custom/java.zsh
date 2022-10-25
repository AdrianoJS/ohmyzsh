###Functions
function changeJava() {
    ln -snf "/opt/oracle/java/jdk$1" /opt/oracle/java/current
}
function whichJava() {
    ls -al /opt/oracle/java/current
}

