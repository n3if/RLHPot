#!/bin/bash

sudo docker-compose down
sudo docker volume rm rlhpot_mysql_volume
sudo docker system prune -f
sudo docker-compose build
sudo docker-compose up
