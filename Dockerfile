# Usa una imagen base de Node.js
FROM node:14

# Instala CUPS y las dependencias necesarias
RUN apt-get update && apt-get install -y \
  cups \
  libcups2-dev

# Configura CUPS
RUN /etc/init.d/cups start

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Expone el puerto en el que tu aplicación escucha
EXPOSE 3000

# Comando para ejecutar tu aplicación Node.js
CMD /etc/init.d/cups start && npm start

