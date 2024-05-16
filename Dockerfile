# Usa una imagen base oficial de Node.js
FROM node:14

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Instala pdf-to-printer y otras dependencias necesarias
RUN apt-get update && \
    apt-get install -y libcups2 libcups2-dev libnss-mdns cups && \
    npm install -g pdf-to-printer html-pdf

# Expone el puerto en el que la aplicación se ejecuta
EXPOSE 3000

# Comando para ejecutar la aplicación
CMD ["node", "index.js"]
