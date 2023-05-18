#!/bin/bash

# for gluten
sudo apt update && sudo apt install -y libiberty-dev libdwarf-dev libre2-dev \
    libz-dev libssl-dev libboost-all-dev libcurl4-openssl-dev libjemalloc-dev

# folly cmake bug workaround
sudo mkdir -p /include
# big storage
[[ -d ./storage ]] || ln -s /storage storage
# dependencies
pushd  storage

# # spark 3.2.2
# git clone --depth 1 --branch v3.2.2 https://github.com/apache/spark.git spark322
# pushd spark322
# ./build/mvn -Pyarn -DskipTests clean install
# popd

# # spark 3.3.0
# # git clone --depth 1 --branch v3.3.0 https://github.com/apache/spark.git spark330
# # pushd spark330
# # ./build/mvn -Pyarn -DskipTests clean install
# # popd

# # spark-sql-perf
# git clone --depth 1 https://github.com/databricks/spark-sql-perf.git
# pushd spark-sql-perf
# sbt +package
# popd

# # tpch-dbgen
# git clone https://github.com/databricks/tpch-dbgen
# pushd tpch-dbgen
# git checkout 0469309147b42abac8857fa61b4cf69a6d3128a8
# make clean && make
# popd

# # tpcds-kit
# git clone https://github.com/databricks/tpcds-kit
# pushd tpcds-kit/tools
# sudo apt-get -y install gcc make flex bison byacc git
# make clean && make
# popd

popd
