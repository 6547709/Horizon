#!/bin/bash
certfile=/usr/local/guoqiangli.com/fullchain.cer

currentmd5sum=$(cat /usr/local/guoqiangli.com/cert-md5sum)
newmd5sum=$(md5sum /usr/local/guoqiangli.com/fullchain.cer |awk '{print $1}')

if [ "$currentmd5sum" != "$newmd5sum" ];then
   echo "Found new certificate,starting for update certificate to horizon uag server"
   UAGCERT=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' /usr/local/guoqiangli.com/fullchain.cer)
   UAGCERTKEY=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' /usr/local/guoqiangli.com/guoqiangli.com.key)
   curl  -u 'admin:VMware1!' -H "Content-Type: application/json" -X PUT -d "{\"privateKeyPem\": \"$UAGCERTKEY\",\"certChainPem\": \"$UAGCERT\"}" https://hz-uag.corp.local:9443/rest/v1/config/certs/ssl
   echo "The new certficate has update to horizon uag server"
   echo "Generator new checksum"
   md5sum /usr/local/guoqiangli.com/fullchain.cer |awk '{print $1}'  | cat > /usr/local/guoqiangli.com/cert-md5sum
   echo "Updated md5sum with new certificate"
else
   echo "Not found new certificate!"
fi
