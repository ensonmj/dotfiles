#!/bin/bash

# vscode extensions
declare -a exts=(
    vscjava.vscode-java-pack
    redhat.vscode-xml
    scala-lang.scala
    scalameta.metals
)
for ext in "${exts[@]}"; do
    code --install-extension "$ext"
done

# config
CUR_DIR=$(dirname "${BASH_SOURCE[0]}")
merge_vsconf "${CUR_DIR}/vscode/*" "${WORKSPACE_DIR}/.vscode"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    maven openjdk-8-jdk openjdk-8-source openjdk-8-doc \
    openjdk-11-jdk openjdk-11-source openjdk-11-doc

[[ -d ${WORKSPACE_DIR}/.mvn ]] || ln -s ${CUR_DIR}/mvn ${WORKSPACE_DIR}/.mvn
ln -s ${CUR_DIR}/m2/settings.xml ${HOME}/.m2/settings.xml
ln -s ${CUR_DIR}/sbt/repositories ${HOME}/.sbt/repositories

curl -s "https://get.sdkman.io" | bash
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
sdk install sbt

echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.env
MAVEN_OPTS="$MAVEN_OPTS -Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
# for arrow in java11
# for java17 --add-opens=java.base/java.nio=ALL-UNNAMED 
# https://spark.apache.org/docs/3.2.2/api/python/getting_started/install.html#dependencies
# https://github.com/GoogleCloudDataproc/spark-bigquery-connector/issues/200
JAVA_OPTS="$JAVA_OPTS -Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true"
SBT_OPTS="$SBT_OPTS -Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true"
# metal and bloop should use java11
mkdir -p ~/.bloop && cat << EOF > ~/.bloop/bloop.json
{
    "javaHome":"/usr/lib/jvm/java-11-openjdk-amd64",
    "javaOptions":["-Djdk.module.illegalAccess=permit", "-Dio.netty.tryReflectionSetAccessible=true", "-Xss4m", "-Dfile.encoding=UTF-8"]
}
EOF

if [ -n "$HTTP_PROXY_HOST" -a -n "$HTTP_PROXY_PORT" ]; then
    # replace $HTTP_PROXY_HOST and $HTTP_PROXY_PORT only
    MAVEN_OPTS="$MAVEN_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    SBT_OPTS="$SBT_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    
    TMP=$(mktemp)
    jq ".javaOptions += [\"-Dhttp.proxyHost=$HTTP_PROXY_HOST\", \"-Dhttp.proxyPort=$HTTP_PROXY_PORT\", \"-Dhttps.proxyHost=$HTTP_PROXY_HOST\", \"-Dhttps.proxyPort=$HTTP_PROXY_PORT\"]" ~/.bloop/bloop.json > $TMP && \
    mv $TMP ~/.bloop/bloop.json
fi
echo "MAVEN_OPTS=\"$MAVEN_OPTS\"" >> ~/.env
echo "JAVA_OPTS=\"$JAVA_OPTS\"" >> ~/.env
echo "SBT_OPTS=\"$SBT_OPTS\"" >> ~/.env

# we can't pass jvm options for tester runner(bloop -> sbt.ForkMain)
# so we hack java11 bin directly
sudo mv /usr/lib/jvm/java-11-openjdk-amd64/bin/java{,.bin}
cat << EOF | sudo tee /usr/lib/jvm/java-11-openjdk-amd64/bin/java 
#!/bin/bash
exec /usr/lib/jvm/java-11-openjdk-amd64/bin/java.bin -Djdk.module.illegalAccess=permit -Dio.netty.tryReflectionSetAccessible=true \$@
EOF
sudo chmod +x /usr/lib/jvm/java-11-openjdk-amd64/bin/java
