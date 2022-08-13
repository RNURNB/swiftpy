#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while deploying"; exit 1; }
DoExitLink ()
{ echo "An error occurred while deploying"; exit 1; }
echo Deploying...
OFS=$IFS
IFS="
"


ls

IFS=$OFS
