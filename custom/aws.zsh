dstpostgresql="5432:rds-postgres.cl3rep9ytezr.eu-west-1.rds.amazonaws.com:5432"
dstamq="8162:b-278b8d5e-850d-4325-9a4f-93fc6fd90b03-1.mq.eu-west-1.amazonaws.com:8162"
dstlb="8080:internal-dst-p-ALBIn-18ZGPEV1OA6KG-1818054728.eu-west-1.elb.amazonaws.com:80"
dstlb2="8443:internal-dst-p-ALBIn-18ZGPEV1OA6KG-1818054728.eu-west-1.elb.amazonaws.com:443"

fatpostgresql="5432:fat-postgres-rds-aurora-auroradbcluster-129oh9jltnl8q.cluster-c0mdyaax23jt.eu-west-1.rds.amazonaws.com:5432"
fatamq="8162:b-567cc8b0-379d-4a41-9f61-16f2034a4613-1.mq.eu-west-1.amazonaws.com:8162"
fatlb="8080:internal-fat-p-ALBIn-MUPXBE194WCS-1616153913.eu-west-1.elb.amazonaws.com:80"
fatlb2="8443:internal-fat-p-ALBIn-MUPXBE194WCS-1616153913.eu-west-1.elb.amazonaws.com:443"

###Aliases
alias restart-jenkins="aws lambda invoke --function-name embriq-restart-jenkins"
alias bastion="$QUANT_HOME/quant-core-dev-util/aws/bastion.sh"
alias simple-bastion="/data/aws/bastion.sh"

alias dstpostgres="ssh-add /data/aws/dstpostgresql.pem && bastion dstpostgres '-L $dstpostgresql -L $dstamq -L $dstlb -L $dstlb2'"
alias fatpostgres="bastion fatpostgres '-L $fatpostgresql -L $fatamq -L $fatlb -L $fatlb2'"
alias build="ssh-add /data/aws/embriq-quant-flow.pem && bastion build '-L 5432:quantcore-jenkins-postgres.c00u9w2awlhm.eu-west-1.rds.amazonaws.com:5432 -L 9200:master.elastic.internal:9200'"

function sshdstpostgres() {
  ssh -i /data/aws/dstpostgresql.pem ec2-user@$1
}
