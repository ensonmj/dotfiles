#!/bin/bash

curl -s "https://get.sdkman.io" | bash
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
sdk install sbt

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
if [ -n "$HTTP_PROXY_HOST" -a -n "$HTTP_PROXY_PORT" ]
then
    # replace $HTTP_PROXY_HOST and $HTTP_PROXY_PORT only
    MAVEN_OPTS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    JAVA_OPTS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    SBT_OPTS="-Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT -Dhttps.proxyHost=$HTTP_PROXY_HOST -Dhttps.proxyPort=$HTTP_PROXY_PORT"
    sed -i "s/<active>disable</active>/<active>enable</active>/g" ~/.m2/settings.xml
    sed -i "s/HTTP_PROXY_HOST/$HTTP_PROXY_HOST/g" ~/.m2/settings.xml
    sed -i "s/8888/$HTTP_PROXY_PORT/g" ~/.m2/settings.xml
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
echo "export MAVEN_OPTS=\"-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g $MAVEN_OPTS\"" >> ~/.profile
echo "export JAVA_OPTS=\"$JAVA_OPTS\"" >> ~/.profile
echo "export SBT_OPTS=\"$SBT_OPTS\"" >> ~/.profile

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
