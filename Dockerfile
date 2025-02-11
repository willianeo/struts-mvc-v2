FROM ubuntu:18.04

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y wget tar

# Copia o JDK manualmente baixado para dentro da imagem Docker
COPY jdk-6-linux-amd64.bin /tmp/jdk-6.bin
RUN chmod +x /tmp/jdk-6.bin && echo "yes" | /tmp/jdk-6.bin && mv jdk1.6.0 /usr/local/java6 && rm /tmp/jdk-6.bin    

# Definir variáveis de ambiente para o Java 6
ENV JAVA_HOME=/usr/local/java6
ENV PATH="$JAVA_HOME/bin:$PATH"

# Baixar e instalar o Tomcat 6
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.53/bin/apache-tomcat-6.0.53.tar.gz -O /tmp/tomcat.tar.gz && \
    tar -xzf /tmp/tomcat.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-6.0.53 /usr/local/tomcat6 && \
    rm /tmp/tomcat.tar.gz

# Expor a porta do Tomcat
EXPOSE 8080

# Definir o diretório de trabalho
WORKDIR /usr/local/tomcat6

# Copiar a aplicação WAR para o Tomcat
COPY target/*.war /usr/local/tomcat6/webapps/

# Comando para iniciar o Tomcat
CMD ["/usr/local/tomcat6/bin/catalina.sh", "run"]
