DEFAULT_TCP_PORTS="21,22,23,25,53,79,80,110,111,135,139,162,389,443,445,512,513,514,623,624,1099,1433,1524,2049,2121,3306,3128,3310,3389,3632,4443,5432,5800,5900,5984,6667,8000,8009,8080,8180,8443,8888,10000,16992,27017,27018,27019,28017,49152"
DEFAULT_UDP_PORTS="53,67,68,88,161,162,137,138,139,389,520,2049"
UNUSED_UDP_PORT="58885"
OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'

echo -e "$OKORANGE )                       "
echo -e "$OKORANGE ( /(                     "
echo -e "$OKORANGE )\())    )       )        "
echo -e "$OKRED ((_)\    (     ( /(  \`  )  "
echo -e "$OKBLUE  _"$OKRED"(("$OKBLUE"_"$OKRED")   )\  ' )(_)) /(/(   "
echo -e "$OKBLUE | \| | _"$OKRED"(("$OKBLUE"_"$OKRED")) (("$OKBLUE"_"$OKRED")"$OKBLUE"_ "$OKRED"(("$OKBLUE"_"$OKRED")"$OKBLUE"_"$OKRED"\  "
echo -e "$OKBLUE | .\` || '  \("$OKRED")"$OKBLUE"/ _\` || '_ \ "$OKRED") "
echo -e "$OKBLUE |_|(_||_|_|_| \__,_|| .__/  "
echo -e "$OKORANGE ( )\          )    ("$OKBLUE"|_|    "
echo -e "$OKORANGE )((_)  (     (    )"$OKBLUE"_"$OKRED"\())   "
echo -e "$OKRED ("$OKBLUE"_"$OKRED")"$OKBLUE"_"$OKRED"   )\    )\  "$OKBLUE" | |"$OKRED"((_)\    "
echo -e "$OKBLUE | _ ) $OKRED(("$OKBLUE"_"$OKRED") "$OKBLUE"_"$OKRED"(("$OKBLUE"_"$OKRED")) "$OKBLUE"| |"$OKRED"("$OKBLUE"_"$OKRED")   "
echo -e "$OKBLUE | _ \/ _ \| '  \("$OKRED")"$OKBLUE"| '_ \   "
echo -e "$OKBLUE |___/\___/|_|_|_| |_.__/ "
echo ""
echo -e "$OKGREEN [NmapBomb v0.1 by Ifly53E] $RESET"


# COMMAND LINE SWITCHES
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    echo ""
    echo "NmapBomb by Ifly53E"
    echo "defaults are: -t T3, --top-ports 1000, -PO1,2,4,16,17,132, -f TARGET_PORT_$(date +'%FT%H%M%S%3N').xml"
    echo "Usage for defaults: nmapbomb -i 192.168.48.0/24"
    echo "Usage to change defaults: nmapbomb -i 192.168.48.0/24  -f myfilename.xml -o 1,2,4 -t T4 -p 100"
    echo ""
    shift # past argument
    exit
    ;;
    -i|--ipaddress)
    TARGET="$2"
    shift # past argument
    shift # past argument
    ;;
    -p|--port)
    PORT="$2"
    PORT1=$"--top-ports "$PORT
    #PORT1="-p "$PORT
    #echo "port is: " $PORT
    shift # past argument
    shift # past argument
    ;;
    -f|--file)
    FILE="$(realpath $2)"
    shift # past argument
    shift # past argument
    ;;
    -o|--POPORTS)
    POPORTS="$2"
    shift # past argument
    shift # past argument
    ;;
    -t|--time)
    TIME="$2"
    shift # past argument
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    echo "Unknown scan option $POSITIONAL...refer to the help menu for usage details."
    exit
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z $TARGET ]; then
  echo "Need an ip address.  Use -i <IP> "
  exit
fi

if [ -z $PORT ]; then
  echo "Defaulting to --top-ports <1000>.  Use -p <ports> to change to the number of ports to scan. "
  PORT1=$"--top-ports 1000"
fi

if [ -z $TIME ]; then
  echo "Default to T3.  Use -t <T0-5> to change"
  TIME="T3"
fi

if [ -z $POPORTS ]; then
  echo "Default to -PO of \"1,2,4,16,17,132\".  Use --POPORTS <PORTS> to change."
  POPORTS="1,2,4,16,17,132"
fi

if [ -z $FILE ]; then
  echo "Default to file name of "$TARGET"_"$PORT"_SYSTIME.  Use -f <filename> to change."
  DIR_NAME=$TARGET_$PORT_$(date +'%FT%H%M%S%3N')
  mkdir -p $DIR_NAME
  cd $DIR_NAME
  FILE="$DIR_NAME.xml"
else
  DIR_NAME=$FILE_$(date +'%FT%H%M%S%3N')
  mkdir -p $DIR_NAME
  cd $DIR_NAME
fi

#not sure that top-port does anything so taking it out...
PORT1=""

LINES1=$(wc -l ../hostDiscovery.txt | cut -d " " -f1)
LINES2=$(wc -l ../scanPorts.txt | cut -d " " -f1)
TOTAL_LINES=$(( $LINES1 + $LINES2 ))

SCAN_NUM=0
function runNum {
  SCAN_NUM=$((SCAN_NUM + 1 ))
  echo -e "$OKRED $SCAN_NUM of $TOTAL_LINES $RESET"
}

echo -e "$OKGREEN + -- ----------------------------=[Running Host Discovery]=--------------- -- +$RESET"

while read line
do
   echo ""
   echo ""
   runNum
   echo -e $OKGREEN
   eval echo -e $line
   echo -e $RESET
   eval $line
done < ../hostDiscovery.txt

echo -e "$OKGREEN + -- ----------------------------=[Sorting Discovered Hosts]=--------------- -- +$RESET"

grep "addrtype=\"ipv4\"" *.xml | cut -d"\"" -f2 > allips.txt
sort -u allips.txt > sorted.txt
cat sorted.txt

echo -e "$OKGREEN + -- ----------------------------=[Running Port Scan on Discovered Hosts]=--------------- -- +$RESET"

while read line
do
  echo ""
  echo ""
  runNum
  echo -e $OKGREEN
  eval echo -e $line
  echo -e $RESET
  eval $line
done < ../scanPorts_ordered.txt

echo -e "$OKGREEN + -- ----------------------------=[Opening Zenmap with results]=--------------- -- +$RESET"
mkdir -p $DIR_NAME"TEXT"
mv *.txt $DIR_NAME"TEXT"
zenmap -f ../$DIR_NAME &

echo -e "$OKGREEN + -- ----------------------------=[Exiting NmapBomb sh script]=---------------------- -- +$RESET"
exit
