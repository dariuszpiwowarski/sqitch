#!/bin/bash

set -e

version=${1:-7}
echo $version

# Download dependencies.
if [ -z "$SKIP_DEPENDS" ]; then
    sudo apt-get update -qq
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -qq curl unixodbc-dev odbcinst unixodbc default-jre
    cat t/odbc/odbcinst.ini | sudo tee -a /etc/odbcinst.ini
fi

# Prepare the configuration.
mkdir -p /opt/exasol

# Download and unpack Exasol ODBC Driver & EXAplus.
# https://www.exasol.com/portal/display/DOWNLOAD/
if [[ "$version" =~ ^6 ]]; then
    curl -sSLO https://www.exasol.com/support/secure/attachment/111075/EXASOL_ODBC-6.2.9.tar.gz
    curl -sSLO https://www.exasol.com/support/secure/attachment/111057/EXAplus-6.2.9.tar.gz
    sudo tar -xzf EXASOL_ODBC-6.2.9.tar.gz -C /opt/exasol --strip-components 1
    sudo tar -xzf EXAplus-6.2.9.tar.gz     -C /opt/exasol --strip-components 1
else
    curl -sSLO https://www.exasol.com/support/secure/attachment/175398/EXASOL_ODBC-7.1.3.tar.gz
    curl -sSLO https://www.exasol.com/support/secure/attachment/175394/EXAplus-7.1.3.tar.gz
    sudo tar -xzf EXASOL_ODBC-7.1.3.tar.gz -C /opt/exasol --strip-components 1
    sudo tar -xzf EXAplus-7.1.3.tar.gz     -C /opt/exasol --strip-components 1
fi

# Add to the path.
if [[ ! -z "$GITHUB_PATH" ]]; then
    echo "/opt/exasol" >> $GITHUB_PATH
fi