export LOCALHOST=(localhost 5434 quant_core)
export AWS=(localhost 5432 quant_core)
export DST1="eqhv-ora-t01.h.ncop.net:1521/QDST1"
export DST2="eqhv-ora-t01.h.ncop.net:1521/QUANT_DST_MAINT"
export DST3="eqhv-ora-t01.h.ncop.net:1521/QDST_2_16"
export FAT="aehv-fatora-t01.h.ncop.net:1521/PQFAT"
export LOCAL="192.168.56.101:1521/XE"

### FUNCTIONS
function execute-sql() {
  if [ -n "$4" ]; then
    PATH=$PATH && psql --host $1 --port $2 --dbname $3 --username $4
  else
    echo $1
    echo $2
    echo $3
    echo $4
    echo "Missing username parameter"
  fi
}

function pgsql() {
  HOST=($LOCALHOST)
  if [ -n "$2" ]; then
    case "$2" in
      aws)
        HOST=($AWS)
        ;;
      local*)
        HOST=($LOCALHOST)
        ;;
      *)
        echo "Unknown destination"
        echo "Valid options: aws, local*"
        echo "Defaulting to localhost"
        HOST=($LOCALHOST)
    esac
  fi

  case "$1" in
    *user*|quant_*)
      execute-sql $HOST $1
      ;;
    qc)
      execute-sql $HOST qcuser
      ;;
    mdm)
      execute-sql $HOST mdmuser
      ;;
    cip)
      execute-sql $HOST cipuser
      ;;
    root)
      execute-sql $HOST postgres
      ;;
    *)
      echo "Unknown database user"
      echo "Valid options: qc, mdm, cip"
  esac
}

function osql() {
  HOST=$DST1
  
  if [ -n "$2" ]; then
    case "$2" in
      dst1)
        HOST=$DST1
        ;;
      dst2)
        HOST=$DST2
        ;;
      dst3)
        HOST=$DST3
        ;;
      fat)
        HOST=$FAT
        ;;
      local)
        HOST=$LOCAL
        ;;
      *)
        echo "Unknown destination"
        echo "Valid options: aws, local*"
        echo "Defaulting to dst1"
        HOST=$DST1
    esac
  fi
    
  case "$1" in
    quant_*)
      sql $1@$HOST
      ;;
    qc)
      sql quant_qc@$HOST
      ;;
    mdm)
      sql quant_mdm@$HOST
      ;;
    jms)
      sql quant_jms@$HOST
      ;;
    rio)
      sql rio_xe_vm_v2@$HOST
      ;;
    *)
      echo "Unknown database user"
      echo "Valid options: qc, mdm, jms"
  esac
}
