FROM node:7
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]


#Choosing a base image
#You may wonder why we chose this specific image as your base. Because your app is a Node.js app,
#you need your image to contain the node binary executable to run the app. You could have used any
#image that contains that binary, or you could have even used a Linux distro base image such as fedora
#or ubuntu and installed Node.js into the container at image build time. But because the node image
#is made specifically for running Node.js apps, and includes everything you need to run your app,
#you’ll use that as the base image.
