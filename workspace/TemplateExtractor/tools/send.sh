#! /bin/bash
# Author: qjp
# Date: <2013-04-17 Wed>

PROJECT_DIR="$HOME/Programs/BachelorThesis/workspace/TemplateExtractor"
JAR_PATH="$PROJECT_DIR/target/scala-2.9.2/templateextractor_2.9.2-0.1-SNAPSHOT.jar"
ONE_JAR_PATH="$PROJECT_DIR/target/scala-2.9.2/templateextractor_2.9.2-0.1-SNAPSHOT-one-jar.jar"
CLASSES_DIR="$PROJECT_DIR/target/scala-2.9.2/classes"
REMOVE_HOST="qiujunpeng@166.111.138.18"

if [ $# -lt 1 ]; then
    echo "Error! You must supply the main class!"
    exit
fi

mainClass=$1

change_conf() {
    cd $CLASSES_DIR
    mv application.conf $PROJECT_DIR/conf/application.conf.client
    mv $PROJECT_DIR/conf/application.conf.server application.conf
}

change_back() {
    cd $CLASSES_DIR
    mv application.conf $PROJECT_DIR/conf/application.conf.server
    mv $PROJECT_DIR/conf/application.conf.client application.conf
}

make_jar() {
    if [ -x $JAR_PATH ]; then
        rm  $JAR_PATH
    fi
    if [ -x $ONE_JAR_PATH ]; then
        rm $ONE_JAR_PATH
    fi
    cd $PROJECT_DIR
    tools/onejar.sh $mainClass
}

copy_to_server() {
    scp $ONE_JAR_PATH $REMOVE_HOST:/home/qiujunpeng/prog/
}

change_conf
make_jar
change_back
copy_to_server

if [ $# -eq 2 ]; then
    ssh $REMOVE_HOST -t "cd prog && java -jar templateextractor_2.9.2-0.1-SNAPSHOT-one-jar.jar"
fi