# SELT_Team_Project

## Docker Notes
Steps to setup initial docker compose development. 
1) Ensure that docker desktop is running in the background        
2) run: ```docker-compose up -d --build```
3) run docker ps and check that all 4 containers are running

To spool down the containers run: ```docker-compose down```

To restart containers run: 
```docker restart \<container name>```. You can view container names by running docker ps

To go into the docker's container:
```docker exec -it selt-team-project-ruby-1 bash```

# test
