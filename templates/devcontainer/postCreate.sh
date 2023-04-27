#!/bin/bash

if [ -n "$HTTP_PROXY" ]
then
    echo "http_proxy=$HTTP_PROXY" >> ~/.wgetrc
    echo "https_proxy=$HTTP_PROXY" >> ~/.wgetrc
fi

pushd ~/.dotfiles
stow -S zsh
stow -S profile
stow -S bash
popd

sudo apt update
sudo apt install -y zsh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
# sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $HOME/.sdkman/etc/config
sdk install sbt

# big storage
[[ -d ./storage ]] || ln -s /storage storage
# dependencies
pushd  storage

popd

