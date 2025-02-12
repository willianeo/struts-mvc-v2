# struts-mvc-v2

# As seguintes Libs devem ser adicionadas no diretorio: struts-mvc-v2/struts-mvc-webapp/WebContent/WEB-INF/lib
total 7792
antlr-2.7.6.jar
commons-beanutils-1.8.0.jar
commons-chain-1.2.jar
commons-collections-3.1.jar
commons-digester-1.8.jar
commons-lang-2.2.jar
commons-logging-1.0.4.jar
commons-validator-1.3.1.jar
dom4j-1.6.1.jar hibernate3.jar
javassist-3.9.0.GA.jar
jta-1.1.jar
mysql-connector-java-5.1.40.jar
oro-2.0.8.jar
servlet-api-2.5.jar
slf4j-api-1.5.8.jar
slf4j-jcl-1.5.5.jar
struts-core-1.3.10.jar
struts-extras-1.3.10.jar
struts-taglib-1.3.10.jar
struts-tiles-1.3.10.jar
velocity-1.6.2.jar


#### Utilizar jdk1.6.0 & apache-tomcat-6.0.53


#### PROCESSO DE COMPILACAO

# Este projeto e um estudo de caso de compilacao manual.
# A ideia e conhecer melhor como e feito oprocesso de compilacao pelas IDEs.

# compilar o projeto - os .class gerados aqui vao para dentro da pasta bin
javac -source 1.6 -target 1.6 -d bin -cp "struts-mvc-webapp/WebContent/WEB-INF/lib/*" $(find struts-mvc-webapp/src -name "*.java")

# copiar as classes compiladas do diretorio bin para o diretorio classes - (Observar se a classe com.demo.domain.Customer.java foi compilada)
cp -r bin/* struts-mvc-webapp/WebContent/WEB-INF/classes/

# copiar tambem arquivos de configuracao como hibernate.cfg.xml e Customer.hbm.xml para dentro do diretorio classes
cp -r struts-mvc-webapp/src/hibernate.cfg.xml struts-mvc-webapp/WebContent/WEB-INF/classes/
cp -r struts-mvc-webapp/src/com/demo/domain/Customer.hbm.xml struts-mvc-webapp/WebContent/WEB-INF/classes/com/demo/domain/

# gerar o artefato.
jar cvf target/struts-mvc-v2.war -C struts-mvc-webapp/WebContent .



#### Comandos uteis no processo de compilacao para resolucao de problemas

# lista as LIBs do projeto informando qual versao da jdk foi utilizada para fazer o Build.
find struts-mvc-webapp/WebContent/WEB-INF/lib/ -name "*.jar" -exec sh -c 'echo {} && unzip -p {} META-INF/MANIFEST.MF | grep "Build-Jdk"' \;

# lista todas as classes do diretorio bin recursivamente informando qual versao do java foi utilizado para gerar o .class
find bin -name "*.class" -exec file {} \;

# descompila a classe DAOFactory e detalha informacoes como qual versao da jdk foi utilizado na compoilacao
javap -verbose bin/com/demo/hibernate/DAOFactory
javap -v -classpath /tmp/war_content/WEB-INF/classes com.demo.action.CustomerAction



#### Comandos uteis Tomcat
# limpar tomcat
rm -rf /usr/local/tomcat6/temp/*
rm -rf /usr/local/tomcat6/work/*
ps -ef | grep java
tail -n 100 -f logs/*



#### alternativa rapida para configurar variavel local no Linux Debian.
export JAVA_HOME=/home/willian/environments/tools/jdk1.6.0/
export PATH=$JAVA_HOME/bin:$PATH



#### Para subir no docker
docker-compose up -d
docker compose up -d --build
docker-compose build --no-cache
docker-compose restart
docker compose down

# Configurando o tomcat a partir da maquina hospedeira.
docker cp tomcat-users.xml tomcat6-app:/usr/local/tomcat6/conf/tomcat-users.xml
docker cp server.xml tomcat6-app:/usr/local/tomcat6/conf/server.xml
docker-compose restart

# se fizer uma alteracao no WAR e precisar subir:
# Se o container já está rodando e você quer apenas substituir o arquivo, faça o seguinte:
# copiar para uma pasta temporaria para depois mover para webapps (isso evita problemas de permissao)
docker cp target/struts-mvc-v2.war tomcat6-app:/tmp/struts-mvc-v2.war
docker exec -it tomcat6-app mv /tmp/struts-mvc-v2.war /usr/local/tomcat6/webapps/
 # verifica se o arquivo foi movido 
docker exec -it tomcat6-app ls -la /tmp

# Depois reinicie o serviço dentro do container (exemplo para Tomcat):
docker exec -it tomcat6-app bash -c "catalina.sh stop; catalina.sh start"
# Ou simplesmente reinicie o container:
docker restart tomcat6-app

# Montar o .war por volume
# se precisar substituir o .war basta sobrescrever o arquivo na pasta target/
cp novo-struts-mvc-v2.war target/struts-mvc-v2.war
# E reiniciar o Tomcat dentro do container sem precisar recriá-lo:
docker exec -it tomcat6-app bash -c "/usr/local/tomcat6/bin/shutdown.sh && sleep 3 && /usr/local/tomcat6/bin/startup.sh"
# preferir pode apenas reiniciar o container
docker restart tomcat6-app



 	



# comando util para acessar o shell
docker exec -it tomcat6-app bash

