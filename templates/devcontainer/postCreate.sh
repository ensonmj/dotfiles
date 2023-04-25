#!/bin/bash

if [ -n "$HTTP_PROXY" ]
then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

# pushd ~/.dotfiles
# stow -S zsh
# stow -S profile
# stow -S bash
# popd

sudo apt update
sudo apt install -y zsh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
# cargo install sccache
cargo install fd-find
cargo install ripgrep
cargo install just

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bashrc
if [ -n "$HTTP_PROXY_HOST" -a -n "$HTTP_PROXY_PORT" ]
then
    echo "export JAVA_OPTS=\"$JAVA_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT\"" >> ~/.bashrc
    echo "export SBT_OPTS=\"$SBT_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT\"" >> ~/.bashrc
    # metal should start after this done
    mkdir -p ~/.bloop && cat << EOF > ~/.bloop/bloop.json
{
    "javaHome":"/usr/lib/jvm/java-8-openjdk-amd64",
    "javaOptions":["-Dhttp.proxyHost=$HTTP_PROXY_HOST", "-Dhttp.proxyPort=$HTTP_PROXY_PORT", "-Dhttps.proxyHost=$HTTP_PROXY_HOST", "-Dhttps.proxyPort=$HTTP_PROXY_PORT"]
}
EOF
    # mvn clean generate-sources ch.epfl.scala:bloop-maven-plugin:2.0.0:bloopInstall -DdownloadSources=true -Pspark-3.2 -Pbackends-velox -Pspark-ut
    # kill -9 `jps | awk '{print $1}'`
fi

curl -s "https://get.sdkman.io" | bash
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install sbt

# # big storage
# ln -s /storage storage
# # dependencies
# pushd  storage

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

# popd

