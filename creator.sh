#!/bin/bash

# --- argument
while [ $# -gt 0 ]; do
    case "$1" in
      # - specify server-id
        "-s" | "-server")
            SERV=$2
            shift
            ;;

        # - set explicit port
        "-p" | "-port")
            PORT=$2
            shift
            ;;

        # - set explicit port
        "-pass" )
            KEYSTORE_PASS=$2
            shift
            ;;

        # - skip remaining arguments
        # - skip remaining arguments
        "--" )
            shift
            break
            ;;
        # unknown argument
        *)
           echo "Invalid argument! [$1]"
           usage
           ;;
    esac
    shift
done

function usage() {
	echo "Usage: "
	echo "-s, -server - use for describing server"
	echo "-p, -port - use for describing port, by defoult used 443"
	echo "-pass - mandatory parameter, this pass you must use in app"
}
if [ "$PORT" = "" ]; then
  PORT=443
fi
echo ${PORT}
#if [$SERVER ]

echo | openssl s_client -connect $SERVER:$PORT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > mycert.pem

export CLASSPATH=lib/bcprov-jdk16-145.jar
CERTSTORE=mystore.bks
if [ -a $CERTSTORE ]; then
    rm $CERTSTORE || exit 1
fi
keytool \
      -import \
      -v \
      -trustcacerts \
      -alias 0 \
      -file <(openssl x509 -in mycert.pem) \
     -keystore $CERTSTORE \
      -storetype BKS \
      -provider org.bouncycastle.jce.provider.BouncyCastleProvider \
      -providerpath /usr/share/java/bcprov.jar \
      -storepass ${KEYSTORE_PASS} 

rm mycert.pem
