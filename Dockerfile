# Usa una imagen base oficial de Node.js
FROM node:14

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instala las dependencias de Node.js
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Instala CUPS y lpr
RUN apt-get update && \
    apt-get install -y libcups2 libcups2-dev cups curl apt-utils lpr && \
    npm install -g html-pdf

# Expone el puerto en el que la aplicación se ejecuta
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["sh", "-c", "service cups start && node index.js"]
