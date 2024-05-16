# Usa una imagen base de Node.js
FROM node:14

# Instala CUPS y las dependencias necesarias
RUN apt-get update && apt-get install -y \
  cups \
  libcups2-dev

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Copia el script de configuración de impresoras
COPY configure-printers.sh /configure-printers.sh

# Asegura permisos de ejecución para el script
RUN chmod +x /configure-printers.sh

# Exposición del puerto del servicio CUPS (si es necesario)
EXPOSE 631

# Expone el puerto en el que tu aplicación escucha
EXPOSE 3000

# Comando para ejecutar tu aplicación Node.js
CMD /etc/init.d/cups start && /configure-printers.sh && npm start
