#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export zkHome=${zkHome:-"/opt/zookeeper"}
zkRep=${zkRep:-false}
zkVer=${zkVer:-"3.4.6"}

useradd -m -d ${zkHome} -s /bin/bash -c "User for zookeeper" -p zookeeper -U zookeeper
chown -R zookeeper:zookeeper ${zkHome}
su - zookeeper -c 'echo "export PATH=${PATH}:"${zkHome}/bin"" >> ~/.bashrc'
echo "export PATH=${PATH}:"${zkHome}/bin"" >> ~/.bashrc
su - zookeeper -c 'export PATH=${PATH}:"${zkHome}/bin"'
export PATH=${PATH}:"${zkHome}/bin"
pushd ${zkHome}
curl -LO "apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-${zkVer}/zookeeper-${zkVer}.tar.gz"
tar -xvf "zookeeper-${zkVer}.tar.gz"
mv zookeeper-${zkVer}/* ../zookeeper
rm -rf "zookeeper-${zkVer}.tar.gz"
mkdir -p /etc/zookeeper
cp -rf conf/* /etc/zookeeper\
popd
mkdir -p /usr/share/zookeeper/templates/conf/
echo "tickTime=2000
dataDir=/opt/zookeeper/data
clientPort=2181" > /usr/share/zookeeper/templates/conf/zoo.conf
echo "tickTime=2000
dataDir=/opt/zookeeper/data
clientPort=2181" > /opt/zookeeper/conf/zoo.cfg

rm -- "$0"
