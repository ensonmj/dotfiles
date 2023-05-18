#!/bin/bash

if [ -d "$HOME/.host" ]; then
    # "ssh -X" change inode of ".Xauthority", so it can't keep sync with host, then authentication will faild
    # https://medium.com/@jonsbun/why-need-to-be-careful-when-mounting-single-files-into-a-docker-container-4f929340834
    ln -s "$HOME/.host/.Xauthority" "$HOME/.Xauthority"
fi

# "docker run --hostname=dev" not add entry into /etc/hosts
echo $(hostname -I | cut -d\  -f1) $(hostname) | sudo tee -a /etc/hosts
# if kernel.yama.ptrace_scope in /etc/sysctl.d/10-ptrace.conf not set to 0
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

if [ -n "$HTTP_PROXY" ]
then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

if [ -d "$HOME/.dotfiles" ]; then
    rm -f ~/.profile ~/.bashrc ~/.bash_profile ~/.zshrc
    pushd "$HOME/.dotfiles"
    bash install.sh
    bash install_nerdfonts.sh
    popd
fi

curl -s "https://get.sdkman.io" | bash
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
sdk install sbt

echo 'export MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"' >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
if [ -n "$HTTP_PROXY_HOST" -a -n "$HTTP_PROXY_PORT" ]
then
    # replace $HTTP_PROXY_HOST and $HTTP_PROXY_PORT only
    JAVA_OPTS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    SBT_OPTS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    # metal and bloop should use java11
    # metal should start after this done
    mkdir -p ~/.bloop && cat << EOF > ~/.bloop/bloop.json
{
    "javaHome":"/usr/lib/jvm/java-11-openjdk-amd64",
    "javaOptions":["-Djdk.module.illegalAccess=permit", "-Dio.netty.tryReflectionSetAccessible=true", "-Xss4m", "-Dfile.encoding=UTF-8", "-Dmaven.multiModuleProjectDirectory=/workspaces/gluten", "-Dhttp.proxyHost=$HTTP_PROXY_HOST", "-Dhttp.proxyPort=$HTTP_PROXY_PORT", "-Dhttps.proxyHost=$HTTP_PROXY_HOST", "-Dhttps.proxyPort=$HTTP_PROXY_PORT"]
}
EOF
    # mvn generate-sources ch.epfl.scala:bloop-maven-plugin:2.0.0:bloopInstall -DdownloadSources=true -Pspark-3.2 -Pbackends-velox -Pspark-ut
    # kill -9 `jps | grep -v Jps | awk '{print $1}'`
fi
echo "export JAVA_OPTS=\"$JAVA_OPTS\"" >> ~/.bashrc
echo "export SBT_OPTS=\"$SBT_OPTS\"" >> ~/.bashrc

# for arrow in java11
# for java17 --add-opens=java.base/java.nio=ALL-UNNAMED 
# https://spark.apache.org/docs/3.2.2/api/python/getting_started/install.html#dependencies
# https://github.com/GoogleCloudDataproc/spark-bigquery-connector/issues/200
# echo "export JAVA_OPTS=\"-Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true $JAVA_OPTS\"" >> ~/.bashrc
# echo "export SBT_OPTS=\"-Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true $SBT_OPTS\"" >> ~/.bashrc

# we can't pass jvm options for tester runner(bloop -> sbt.ForkMain)
# so we hack java11 bin directly
sudo mv /usr/lib/jvm/java-11-openjdk-amd64/bin/java{,.bin}
cat << EOF | sudo tee /usr/lib/jvm/java-11-openjdk-amd64/bin/java 
#!/bin/bash
exec /usr/lib/jvm/java-11-openjdk-amd64/bin/java.bin -Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true \$@
EOF
sudo chmod +x /usr/lib/jvm/java-11-openjdk-amd64/bin/java

# for gluten
sudo apt-get update
sudo apt install -y libiberty-dev libdwarf-dev libre2-dev libz-dev \
    libssl-dev libboost-all-dev libcurl4-openssl-dev libjemalloc-dev

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

