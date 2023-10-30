# SELT_Team_Project

## Docker Notes
Steps to setup initial docker compose development. 
1) Ensure that docker desktop is running in the background        
2) run: ```docker-compose up -d --build```
3) run docker ps and check that all 4 containers are running
4) Open the web app url and see if the dashboard is there. 
5) Development is now setup for hot reload, so save changes in index.js/index.html and they will show up in the browser right after a webpage reload. 
6) If this doesn't work...... 

To spool down the containers run: ```docker-compose down```

To restart containers run: 
```docker restart \<container name>```. You can view container names by running docker ps
# test
