#!/usr/bin/env bash

# Get the ARN of any cert in AWS.


##### Functions

function getCertArn
{
    var=$(aws iam list-server-certificates --query 'ServerCertificateMetadataList[*].[ServerCertificateName, Arn]' --output text | grep $certName)
    if ["$var" == ""]; then
        echo "Unable to find cert name: $certName"
    else
        echo $var | awk '{print $2}'
    fi

}

function usage
{
    echo "usage: NameToArn [[-c cert name] | [-h]]\n"
    echo "If the cert is found then the ARN will be displayed."
    echo "Example:\n NameToArn.sh -c example.com\n Output: arn:aws:iam::225475123587:server-certificate/example"
}

##### Main

# Take the arguments pass to the shell script and process them.
while [ "$1" != "" ]; do
    case $1 in
        -c | --cert )           shift
                                certName=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
                                # Used for incorrect prams.
        * )                     usage
                                exit 1
    esac
    shift
done

# if no args are passed then print the usage.
if [ "$certName" == "" ]; then
    usage
    exit 1
fi

getCertArn
