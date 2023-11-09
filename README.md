# SELT_Team_Project

## Docker Notes
Steps to setup initial docker compose development. 
1) Ensure that docker desktop is running in the background        
2) run: ```docker-compose up -d --build```
3) Check that the rails app container is running with ```docker ps```
4) Enter ```localhost:3000``` into your browser of choice to view the application
   
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
