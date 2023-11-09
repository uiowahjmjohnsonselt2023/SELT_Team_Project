# SELT_Team_Project

This application is the SELT final project where we are tasked at creating a marketplace application for the customer. They want their clients to be able to buy, and sell various products and take a cut of the profits as their buisness model. If the customer decides to log in they should be able to see all products sold, and a see a table of their profits, and even adjust the payscale to see potential future profits. 

## Cloning notes
To run this application, you can either set this up locally in your own environment, or more preferably have a docker engine installed for even easier setup. 
Clone the repo, and ensure you're terminal is located within its directory. You can edit this as any normal rails application. 

## Docker Notes
Steps to setup initial docker compose development. 
1) Ensure that docker desktop is running in the background        
2) run: ```docker-compose up -d --build```
3) Check that the rails app container is running with ```docker ps```
4) For now if you are running this for the first time make sure to db:migrate and db:seed. This is to ensure the development database is setup for your own testing. NOTE: dockerfile will update with these commands in the future. 
6) Enter ```localhost:3000``` into your browser of choice to view the application
   
To enter the interactive shell of the container:
```docker exec -it app bash```

To stop and remove the containers run: ```docker-compose down``` <br />
* Used if you want to remove the container from the docker engine <br />
  
To stop the container run: ```docker-compose stop``` <br />
* This is preferable so the state of the container is saved. 
  
To start the container from a stopped state: ```docker-compose start```

To restart a container run: 
```docker restart <container name>```. You can view container names by running docker ps

## Important: <br/>If any dockerfiles change during development to see those changes the container must be removed and built again. 
